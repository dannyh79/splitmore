import { Sequelize } from 'sequelize';

const sequelize = new Sequelize(
  process.env.PGDATABASE ?? 'splitmore_test',
  process.env.PGUSER ?? 'postgres',
  process.env.PGPASSWORD ?? 'postgres',
  {
    host: process.env.PGHOST ?? 'localhost',
    dialect: 'postgres',
    logging: false,
  },
);

export default sequelize;
