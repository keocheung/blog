default:
    just --list

# create a new post
new NAME:
    hugo new posts/{{NAME}}.md

# local test
test:
    hugo server -D