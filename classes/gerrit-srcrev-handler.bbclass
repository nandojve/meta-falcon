# -*- python -*-
# gerrit-srcrev-handler.bbclass
# Copyright (C) 2017 Gerson Fernando Budke.  All Rights Reserved
# Released under the MIT license (see packages/COPYING)
#
# This class manage strategy of build of project components of a product.
# The class select a file that describe the recipe with branch and version
# to be used to build delelopment releases. This can be used on top of
# tree build without any penalty to release stable versions.
#
# The file should have the following format:
#
# <recipe> <version> <branch> <hash> <repository>
#
# To use the top of tree for building the user must define:
#
#  - GERRIT_STRATEGY: Select the file name to be loaded and parse to collect
#    recipe information. This is optional and the default strategy is
#    'stable'. This file MUST define branch 'master' and the 'hash' MUST
#    point to stable revisions.
#
#  - GERRIT_CONFDIR: This must point to directory to search the strategy. A
#    good sample is: ${HOME}/source/config/<strategy repository>
#
#  - GERRIT_MODE: Mode select origin from hash code:
#     '0' Nothing to be done, uses srcrev/branch from recipes [default mode]
#     '1' the hash from file is used as stable
#     '2' unknown value, uses 'git ls-remote' to find the top most hash at
#     pointed branch.
#     '3' Uses gerrit patchset with 'gerrit-fetcher2.bbclass' to switch from
#     original branch to 'nobranch=1' option. This provide a way to verifier
#     any commit send to gerrit review. The option 3 uses the same method of
#     option 2 but switch local branch to review branch for the changes of
#     the patchset.
#
#  - GERRIT_EVENT: Gerrit event that triggers jenkins to call bitbake.
#
#  - GERRIT_HOST: Gerrit server host to be search.
#
#  - GERRIT_PROJECT: Gerrit project to be search to apply modification.
#
#  - GERRIT_BRANCH: Gerrit branch to be search to apply modification. This is
#    the current branch were the patchset will enter.
#
#  - GERRIT_PATCHSET: Gerrit SRCREV value to be added.

include conf/gerrit-patchset.conf
inherit gerrit-fetcher

def print_separator(d):
    bb.plain("================================================================================")

def get_strategy(d):
    strategy = d.getVar('GERRIT_STRATEGY', True)
    if strategy:
        return(strategy)
    return ('stable')

def get_mode(d):
    mode = d.getVar('GERRIT_MODE', True)
    if mode:
        return(mode)
    return('0')

def gerrit_git_ls_remote(repository, branch):
    import subprocess

    cmd = ['git', 'ls-remote', repository, branch]

    try:
        output = subprocess.check_output(cmd).decode("utf-8")
        return output.split('\t')[0]
    except:
        return None

def gerrit_strategy_patchset(d, recipes):
    gerrit_event = d.getVar('GERRIT_EVENT', True)
    if not gerrit_event:
        return

    bb.note("Gerrit SRCREV handler: [Event]     '%s' trigger." % gerrit_event)

    gerrit_repository = d.getVar('GERRIT_HOST', True) + '/' + d.getVar('GERRIT_PROJECT', True)
    gerrit_branch = d.getVar('GERRIT_BRANCH', True)
    gerrit_patchset = d.getVar('GERRIT_PATCHSET', True)

    srcrevs_fd = open(recipes, 'r')
    print_separator(d)
    for line in srcrevs_fd.readlines():
        bb.plain(line.rstrip())

    print_separator(d)
    srcrevs_fd.seek(0, 0)
    for line in srcrevs_fd.readlines():
        pkg, version, srcrev, branch, repository = line.split()

        if gerrit_repository in repository and gerrit_branch == branch:
            d.setVar("GERRIT_RECIPE_EVENT_pn-%s" % pkg, gerrit_event)
            d.setVar("GERRIT_RECIPE_REPOSITORY_pn-%s" % pkg, gerrit_repository)
            srcrev = gerrit_patchset
            bb.note("Gerrit SRCREV handler: [patchset]  %s %s" % (srcrev, branch))
        else:
            srcrev = gerrit_git_ls_remote(repository, branch)
            bb.note("Gerrit SRCREV handler: [ls-remote] %s %s" % (srcrev, branch))

        d.setVar("SRCREV_pn-%s" % pkg, srcrev)
        d.setVar("SRCBRANCH_pn-%s" % pkg, branch)
    srcrevs_fd.close()
    print_separator(d)

def gerrit_strategy_remote(d, recipes):
    srcrevs_fd = open(recipes, 'r')
    print_separator(d)
    for line in srcrevs_fd.readlines():
        bb.plain(line.rstrip())

    print_separator(d)
    srcrevs_fd.seek(0, 0)
    for line in srcrevs_fd.readlines():
        pkg, version, srcrev, branch, repository = line.split()

        srcrev = gerrit_git_ls_remote(repository, branch)

        if srcrev is None:
            bb.note("Gerrit SRCREV handler: [ls-remote] None %s" % (branch))
        else:
            bb.note("Gerrit SRCREV handler: [ls-remote] %s %s" % (srcrev, branch))
            d.setVar("SRCREV_pn-%s" % pkg, srcrev)
            d.setVar("SRCBRANCH_pn-%s" % pkg, branch)
    srcrevs_fd.close()
    print_separator(d)

def gerrit_strategy_file(d, recipes):
    srcrevs_fd = open(recipes, 'r')
    print_separator(d)
    for line in srcrevs_fd.readlines():
        pkg, version, srcrev, branch, repository = line.split()

        bb.plain(line.rstrip())

        d.setVar("SRCREV_pn-%s" % pkg, srcrev)
        d.setVar("SRCBRANCH_pn-%s" % pkg, branch)
    srcrevs_fd.close()
    print_separator(d)

def gerrit_srcrev_handler(d):
    warn = False
    recipes = d.getVar('GERRIT_CONFDIR', True)
    if not recipes:
        bb.warn("Gerrit SRCREV handler: GERRIT_CONFDIR is not set, bypassing this class...")
        return

    strategy = d.getVar('GERRIT_STRATEGY', True)
    if not strategy:
        warn = True
        strategy = get_strategy(d)
        bb.warn("Gerrit SRCREV handler: GERRIT_STRATEGY is not set, using default '%s'" % strategy)

    if not os.path.exists(recipes):
        bb.error("Gerrit SRCREV handler: '%s' doesn't exists." % recipes)
        return

    recipes += '/' + strategy + '.conf'

    mode = d.getVar('GERRIT_MODE', True)
    if not mode:
        warn = True
        mode = get_mode(d)
        bb.warn("Gerrit SRCREV handler: GERRIT_MODE is not set, using default '%s'" % mode)

    message = "Gerrit SRCREV handler: Using strategy '%s' mode '%s'." % (recipes, mode)
    if warn:
        bb.warn(message)
    else:
        bb.note(message)

    if mode == '3':
        gerrit_strategy_patchset(d, recipes)
    elif mode == '2':
        gerrit_strategy_remote(d, recipes)
    elif mode == '1':
        gerrit_strategy_file(d, recipes)
    elif mode == '0':
        # Do nothing, validate input
        pass
    else:
        bb.error(1, "Gerrit SRCREV handler: Gerrit mode %s is invalid." % mode)
        return

addhandler gerrit_srcrev_eventhandler
python gerrit_srcrev_eventhandler() {
    if bb.event.getName(e) == "ConfigParsed":
        gerrit_srcrev_handler(e.data)
}
