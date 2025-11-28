// @ts-check
import CDP from 'chrome-remote-interface';
import notifier from 'node-notifier';
import { exec } from 'node:child_process';
import { promisify } from 'node:util';


async function run() {
  try {
    const {branch, repository} = await getBranchNameAndRepository()
    console.log(branch, repository);

    await gitCheckout(repository, branch)
    await openInCode(repository)

  } catch (error) {
    notify('some error?')
    // @ts-ignore
    notify(error.message)
  }

  process.exit()
};


void run()

async function getBranchNameAndRepository () {
  const client = await CDP();
  const { Target, Runtime } = client;

  const targets = await Target.getTargets();
  const active = targets.targetInfos.find(t => t.type === "page" && t.attached);

  if(!active) {
    throw notify(`no active tab`)
  }

  const {url} = active
  const [,,,,repository] = url.split('/')

  if (!url.match(/https:\/\/gitlab.v1t.eu\/.*\/merge_requests\/[0-9]+/)) {
    throw notify(`Wrong url ${url}`)
  }
  
  const result = await Runtime.evaluate({
    expression: `document.querySelector('.ref-container')?.innerText`,
    returnByValue: true
  });

  const branch = result.result.value
  
  if(!branch) {
    throw notify(`Missing branch name in ${url}`)
  }

  return {branch, repository}
}

/**
 * @param {string} repo
 */
async function openInCode(repo) {
  return await cmd(`code ${getRepoDir(repo)}`)
}

/**
 * @param {string} repo
 */
async function getGitBranchFromDir(repo) {
  return await cmd('git symbolic-ref --short HEAD', { cwd: getRepoDir(repo) })
}

/**
 * @param {string} repo
 */
async function gitPull(repo) {
  return await cmd('git pull', { cwd: getRepoDir(repo) })
}

/**
 * @param {string} repo
 * @param {string} branch
 */
async function gitCheckout(repo, branch) {
  const dirBranch = await getGitBranchFromDir(repo)
  const isSame = dirBranch === branch

  
  if (isSame) {
    await gitPull(repo)

    return
  }
  
  try{
    await cmd(`git fetch --all`, { cwd: getRepoDir(repo) })
    await cmd(`git checkout ${branch}`, { cwd: getRepoDir(repo) })
  } catch(error) {
    if (error instanceof Error) {
      throw notify(error.message)
    } else {
      console.log(error);
    }

    throw error
  }
}

/**
 * @param {string} repo
 */
function getRepoDir(repo) {
  return `/home/grzegorz/dev/${repo}`;
}

/**
 * @param {string} message
 */
function notify(message) {
  notifier.notify({
    title: 'Gitlab MR helper',
    message: message
  });
}

const execAsync = promisify(exec);
/**
 * @param {string} command
 * @param {{cwd: string}} [options]
 */
async function cmd(command, options) {
  const { stdout } = await execAsync(command, options);

  return stdout.toString().trim()
}