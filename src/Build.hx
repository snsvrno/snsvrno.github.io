package;

using files.Files;
using frontmatter.FrontMatter;
using markdown.Markdown;
using templates.Templates;

import site.Site;

class Build {
	public static function main() {

		Output.reg = new EReg(".*", "g");

		new Site()

			// the markdown & html
			.addFiles({ extensions: ['md', 'markdown'], })
			.addFiles({ area: 'layouts', path: 'partials', extension: 'html', })
			.addFiles({ area: 'layouts', path: 'templates', extension: 'html', })
			.scanFrontMatter()
			.markdown({ renderedExtension: 'html', })
			.template({ templates: 'layouts', metakey: 'layout', defaultTemplate: "main", })
			.build({ deleteBeforeBuild: true, })

			// css styles
			.addFiles({ extension: 'css', area: 'style', path: 'css', })
			.addFiles({ area: 'layouts/style', path: 'templates', extension: 'css', })
			.scanFrontMatter({ area: 'style', })
			.template({ templates: 'layouts/style', area: 'style', defaultTemplate: 'style', })
			.build({ area: 'style', })

		;

	}
}
