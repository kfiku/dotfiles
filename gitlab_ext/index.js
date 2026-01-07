// @ts-check
import CDP from 'chrome-remote-interface';
import notifier from 'node-notifier';
import { exec } from 'node:child_process';
import { stat } from 'node:fs/promises';
import { promisify } from 'node:util';

/**
 * @typedef {Object} Repo
 * @property {string} branch
 * @property {string} group
 * @property {string} repository
 * @property {string} cloneUrl
 */

async function run() {
  try {
    const repo = await getRepoDetails()
    console.log(repo);

    await checkRepoExists(repo)
    openInCode(repo)
    await gitCheckout(repo)

  } catch (error) {
    notify('some error?')
    // @ts-ignore
    notify(error.message)
  }

  process.exit()
};


void run()

/**
 * @returns {Promise<Repo>}
 */
async function getRepoDetails () {
  const client = await CDP();
  const { Target, Runtime } = client;

  const targets = await Target.getTargets();
  const active = targets.targetInfos.find(t => t.type === "page" && t.attached);

  if(!active) {
    throw notify(`no active tab`)
  }

  
  const {url} = active
  const [,,,group,repository] = url.split('/')
  
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

  const cloneUrl = `git@gitlab.v1t.eu:${group}/${repository}.git`

  return {branch, group, repository, cloneUrl}
}

/**
 * @param {Repo} repo
 */
async function checkRepoExists(repo) {
  try {
    await stat(getRepoDir(repo))
  } catch (error) {
    await gitClone(repo)
  }
}

/**
 * @param {Repo} repo
 */
async function openInCode(repo) {
  return await cmd(`code ${getRepoDir(repo)}`)
}

/**
 * @param {Repo} repo
 */
async function getGitBranchFromDir(repo) {
  return await cmd('git symbolic-ref --short HEAD', { cwd: getRepoDir(repo) })
}

/**
 * @param {Repo} repo
 */
async function gitPull(repo) {
  return await cmd('git pull', { cwd: getRepoDir(repo) })
}

/**
 * @param {Repo} repo
 */
async function gitClone(repo) {
  return await cmd(`git clone ${repo.cloneUrl} ${getRepoDir(repo)}`)
}


/**
 * @param {Repo} repo
 */
async function gitCheckout(repo) {
  const dirBranch = await getGitBranchFromDir(repo)
  const isSame = dirBranch === repo.branch

  
  if (isSame) {
    await gitPull(repo)

    return
  }
  
  try{
    await cmd(`git fetch --all`, { cwd: getRepoDir(repo) })
    await cmd(`git checkout ${repo.branch}`, { cwd: getRepoDir(repo) })
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
 * @param {Repo} repo
 */
function getRepoDir({ group, repository }) {
  return `/home/grzegorz/dev/${group}/${repository}`;
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