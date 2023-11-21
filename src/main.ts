import * as core from "@actions/core"
import * as github from "@actions/github"
import assert from "node:assert/strict"

const octokit = github.getOctokit(core.getInput("token"))

const { data: pages } = await octokit.rest.repos.getPages()
assert.equal(pages.build_type, "legacy")

if ()
