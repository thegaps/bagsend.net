#!/usr/bin/python3
'''
Summarises the number of lines of (raw; mostly .org files, not html/images) content that is in the following categories:
 1) Everything that is published; posts, scripts etc.
 2) Unpublished content; drafts, scripts etc.
 3) Unpublished content focused on the site itself; Meta-grumblings, notes, todo's
 4) Not included in any of the above:
        - The about / contact pages, because it would be silly if these weren't published
        - Site code, templates, config, images, docs. These are already all published on github.

Summary is provided in format to C&P into about.org. Unsure how to best do this automatically.

Doing this in python, not bash, because I don't enjoy doing FP math in bash (though wc is definitely legit).

Also noting that I chose to use the pair of terms (published|unpublished). To me this makes "published" data look completed, wheras "unpublished" is missing something. It feels like this choice might provide some imperceptible subconcious push towards making published the default. I could have chosen (public|private), but there is no indication of direction. Or I could have chosen (not-private|private) which feels like it points in the other direction.
'''


'''
We want to find
files; meta, drafts, and posts,
to count the lines,
and of openness boast.
But fore we start,
how will we look?
for files and smarts,
in every nook?
To do this job,
there's a friendly friend,
Let's'''
import glob
'''and tally bagsend!'''


'''
Category 1)
'''
published = glob.glob('../posts/*.org')
published += glob.glob('../drafts/*.org')
published += glob.glob('*.py')
pubLines = 0
print("\nPublished items:")
for pub in published:
    with open(pub) as openFile:
        numLines = len(openFile.readlines())
        print(pub,numLines)
        pubLines += numLines

'''
Category 2)
'''
drafts = (glob.glob('../../drafts/*.org'))
draftLines = 0
print("\nUnpublished draft items:")
for draft in drafts:
    with open(draft) as openFile:
        numLines = len(openFile.readlines())
        print(draft,numLines)
        draftLines += numLines

'''
Category 3)
'''
metaFiles = ['../../../org/projects/bagsend.org']
metaLines = 0
print("\nUnpublished 'meta' items:")
for metaFile in metaFiles:
    with open(metaFile) as openFile:
        numLines = len(openFile.readlines())
        print(metaFile,numLines)
        metaLines += numLines

'''
Summarise
'''
totalLines = pubLines+draftLines+metaLines
opennessPC = (pubLines/totalLines)*100
print("""
Summary:
|Published|{:7}|
|Draft|{:7}|
|Meta|{:7}|
|Total|{:7}|
|% Open|{:7.2f}|
""".format(pubLines,draftLines,metaLines,totalLines,opennessPC))
with open("opennessHistory.csv",'a') as history:
    history.write(str("{},{},{},{},{}\n".format(pubLines,draftLines,metaLines,totalLines,opennessPC)))
