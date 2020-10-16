require('dotenv').config();
const { ApolloServer } = require('apollo-server');
const database = require('./database');

const typeDefs = `

  type Item {
    id: Int
    category: String
    description: String
    price: Float
  }

  type Query {
    items: [Item]
  }

  input ItemInput {
    category: String
    description: String
    price: Float
  }

  type Mutation {
    saveItem(item: ItemInput): Item
  }
`;

const resolvers = {
  Query: {
    async items() {
      const items = await database.query('SELECT * FROM item');
      return items[0];
    }
  },
  Mutation: {
    async saveItem(_, args) {
      const item = args.item;
      await database.query('INSERT INTO item (category, description, price) values (?, ?, ?) ', [item.category, item.description, item.price]);
      const newItem = await database.query('SELECT * FROM item ORDER BY id DESC limit 1');     
      return newItem[0][0];  
    }
  }
};

const server = new ApolloServer({ typeDefs, resolvers });
server.listen(process.env.PORT || 4000);
