import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'Easy to Use',
    Svg: require('@site/static/img/feat_command_line.svg').default,
    description: (
      <>
        This projects is composed by mix tasks, so you can quickly use it by installing global or local in your elixir project.
      </>
    ),
  },
  {
    title: 'Focus on What Matters',
    Svg: require('@site/static/img/feat_hexagonal.svg').default,
    description: (
      <>
        Create your project with the best practices of clean architecture and hexagonal architecture, with predefined settings and adapters.
      </>
    ),
  },
  {
    title: 'Powered by Mix Tasks',
    Svg: require('@site/static/img/feat_elixir.svg').default,
    description: (
      <>
        Make quick actions by running mix tasks, ¿Have an idea? Please create an issue at our project.
      </>
    ),
  },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
