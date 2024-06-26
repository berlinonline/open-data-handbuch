# Berliner Open-Data-Handbuch

This is the source for the "Berliner Open-Data-Handbuch". From the source, different targets can be generated. See the [Makefile](/Makefile) for details.

The following versions exist:

- A professionally produced printed version. The production of this version is not done directly from source, but involves several manual steps. The content is mostly identical, but the printed version contains some things that aren't included in the source (background graphics, an introductory greeting, etc.). The version of the source that was used as the basis for the printed version is tagged as [version 1.0.0](https://github.com/berlinonline/open-data-handbuch/tree/1.0.0).
- A PDF generated directly from the source via [pandoc](https://pandoc.org) (and additional processing).
- An HTML version generated directly from the source via [jekyll](https://jekyllrb.com) (and additional processing) and served through github pages: https://berlinonline.github.io/open-data-handbuch/

If you have issues or suggestions for future content, you're welcome to raise an issue here: https://github.com/berlinonline/open-data-handbuch/issues. Pull requests are welcome as well!

## License

The text, all markdown sources and PDF artifacts of the _Berliner Open-Data-Handbuch_ are published under [Creative Commons Namensnennung 4.0 International Lizenz](https://creativecommons.org/licenses/by/4.0/deed.de) (CC BY 4.0).

For the licenses to the images contained in the _Berliner Open-Data-Handbuch_, please refer to the [Bildverzeichnis](https://berlinonline.github.io/open-data-handbuch/#bildverzeichnis).

All code, including the `Makefile` and the source code in `/bin` is published under the [MIT License](/LICENSE).

