// server.js - Fastify app entry point
import Fastify from 'fastify';
import plugin from './plugin.js';

const PORT = process.env.PORT || 3001;
const fastify = Fastify({ logger: true });

fastify.register(plugin);

fastify.listen({ port: PORT, host: '0.0.0.0' })
  .then(() => {
    console.log(`Backend running at http://localhost:${PORT}`);
  })
  .catch((err) => {
    fastify.log.error(err);
    process.exit(1);
  });
