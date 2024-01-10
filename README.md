This repository uses a disconnected branch system with multiple branches that are unrelated to each other.

1. `main` is the haxe program and build script that is used to build the site
2. `site` is the built site that is served by github

## Detailed About

This is a static site generator written it Haxe to generate [my site](https://snsvrno.github.io). Any of the many generators that already exist would work, but I wanted to make something (I love making things) and now its taylored to me.

### High Level Structure

Fundamentally this is a file processor. You feed it files, tell it what to do to the files, and the have it make the files somewhere else. The file in `src` is setup to create a website, but you could use this as a mail merge, or really anything else.

- `plugins` contains the processor plugins. These will take the files that exist in the site and do something to it.
- `tools` has the core types and classes for the `Site`
- `src` is my specific directions to make my site

The group of files are loaded into "areas". By default there is one area, the "content" area. Additional areas can be used for different kinds of files.

> for example:
>
> - "content" is the actual content of the site
> - "templates" is partial files that will be used to build real files when used with `content`
> - "css" is where we put the content files for the styles
> - "css templates" is partial files that will be used to make the final css files

### Plugins

#### [Files](plugins/file)

Used to add files to the site.

- `addFiles(site:Site, ?options:Options) : Site` : adds files per the options.

##### Options

| Parameter | Type | Default Value | Description |
| ------ | --- | ------| ----- |
| area | String | `"content"` | the area of the site to add the found files |
| path | String | `"content"` | what folder to look for the files |
| extension | String | | what extension to look for, either this or `extensions` is required |
| extensions | Array<String> | | list of extensions to look for, either this or `extension` is required |


