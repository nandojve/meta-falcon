SUMMARY = "Gerrit patch-set review fetch Class"
LICENSE = "CLOSED"

python do_fetch () {
    # check use of gerrit-trigger
    gerrit_event = d.getVar('GERRIT_RECIPE_EVENT', True)
    if gerrit_event:
        # update to refname/branch/refspec
        # switch git uri to use nobranch=1
        srcuri = (d.getVar('SRC_URI', True) or '').split()
        newuri = []
        gituri = (d.getVar('GERRIT_RECIPE_REPOSITORY', True) or '')
        ignore = ['branch', 'tag']
        bb.note("gerrit-fetcher: uri-to-match: ", gituri)
        for uri in srcuri:
            if gituri in uri:
                params = uri.split(';')
                upduri = ''
                for param in params:
                    # ignore elements with 'branch=' or 'tag=' marks
                    if not any(elem in param for elem in ignore):
                        upduri += param + ';'
                newuri += [upduri + 'nobranch=1']
                bb.note("gerrit-fetcher: uri-is-in: ", uri)
            else:
                newuri += [uri]
        d.setVar('SRC_URI', " ".join(newuri))

    # exec normal fetch of all files
    bb.build.exec_func('base_do_fetch', d)
}
