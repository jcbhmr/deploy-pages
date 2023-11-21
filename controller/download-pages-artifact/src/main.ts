import * as core from "@actions/core"
import * as github from "@actions/github"
import assert from "node:assert/strict"
import * as tc from "@actions/tool-cache"
import { mkdir, rename } from "node:fs/promises"
import { dirname, join, resolve } from "node:path"

const octokit = github.getOctokit(core.getInput("token"))
const workerOctokit = github.getOctokit(core.getInput("worker-token"))
const repository = core.getInput("repository")
const runId = parseInt(core.getInput("run-id"))
const pullRequestNumber = parseInt(core.getInput("pull-request-number"))

const artifacts = await workerOctokit.paginate(workerOctokit.rest.actions.listWorkflowRunArtifacts, {
    owner: repository.split("/")[0],
    repo:  repository.split("/")[1],
    run_id: runId
})
const githubPagesArtifactId = artifacts.find(x => x.name === "github-actions")
assert(githubPagesArtifactId, "no 'github-actions' artifact found")

let path = await tc.downloadTool(githubPagesArtifactId.archive_download_url)
path = await tc.extractZip(path)

const previewDir = resolve(repository, pullRequestNumber.toFixed())
await mkdir(dirname(previewDir), { recursive: true })
await rename(path, previewDir)

