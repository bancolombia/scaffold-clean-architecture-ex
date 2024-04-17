// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import {themes as prismThemes} from 'prism-react-renderer';

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Elixir Structure Manager',
  tagline: 'Elixir plugin to create an elixir application based on Clean Architecture following our best practices.',
  favicon: 'img/logo.svg',

  // Set the production url of your site here
  url: 'https://bancolombia.github.io',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'Bancolombia', // Usually your GitHub org/user name.
  projectName: 'scaffold-clean-architecture-ex', // Usually your repo name.

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: './sidebars.js',
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl:
            'https://github.com/bancolombia/scaffold-clean-architecture-ex/tree/main/docs/',
        },
        blog: {
          showReadingTime: true,
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl:
            'https://github.com/bancolombia/scaffold-clean-architecture-ex/tree/main/docs/',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      // Replace with your project's social card
      image: 'img/docusaurus-social-card.jpg',
      navbar: {
        title: 'Elixir Structure Manager',
        logo: {
          alt: 'Elixir Structure Manager Logo',
          src: 'img/logo.svg',
        },
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'tutorialSidebar',
            position: 'left',
            label: 'Docs',
          },
          {to: '/blog', label: 'Blog', position: 'left'},
          {
            href: 'https://github.com/bancolombia/scaffold-clean-architecture-ex',
            label: 'GitHub',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Docs',
            items: [
              {
                label: 'Create a Project',
                to: '/docs/getting-started/create-a-project',
              },
              {
                label: 'Entry Points',
                to: '/docs/getting-started/create-an-entrypoint',
              },
              {
                label: 'Driven Adapters',
                to: '/docs/getting-started/create-an-entrypoint',
              },
              {
                label: 'Configurations',
                to: '/docs/getting-started/applying-configurations',
              },
            ],
          },
          {
            title: 'Community',
            items: [
              {
                label: 'Changelog',
                href: 'https://github.com/bancolombia/scaffold-clean-architecture-ex/blob/main/CHANGELOG.md',
              },
              {
                label: 'Contributing',
                href: 'https://github.com/bancolombia/scaffold-clean-architecture-ex/blob/main/CONTRIBUTING.md',
              },
              {
                label: 'License',
                href: 'https://github.com/bancolombia/scaffold-clean-architecture-ex/blob/main/LICENSE.txt',
              },
            ],
          },
          {
            title: 'More',
            items: [
              {
                label: 'Bancolombia Tech',
                href: 'https://medium.com/bancolombia-tech',
              },
              {
                label: 'GitHub',
                href: 'https://github.com/bancolombia/scaffold-clean-architecture-ex',
              },
              {
                label: 'Hex.pm',
                href: 'https://hex.pm/packages/elixir_structure_manager',
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} Grupo Bancolombia.`,
      },
      prism: {
//        additionalLanguages: ['elixir'],
        theme: prismThemes.github,
        darkTheme: prismThemes.dracula,
      },
    }),
};

export default config;
