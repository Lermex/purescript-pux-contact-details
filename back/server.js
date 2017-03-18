'use strict';

const Hapi = require('hapi');
const Boom = require('boom');

const db = require('./db');

db.init();

const server = new Hapi.Server();
server.connection({ port: 5000, host: 'localhost' });

server.route({
    method: 'GET',
    path: '/',
    handler: function (request, reply) {
        reply('Hello, world!');
    }
});

server.route({
    method: 'GET',
    path: '/{name}',
    handler: function (request, reply) {
        reply('Hello, ' + encodeURIComponent(request.params.name) + '!');
    }
});

server.route({
    method: 'GET',
    path: '/users/{id}',
    handler: function (request, reply) {
        db.User.findById(request.params.id).then(user => {
          if (user) {
            return reply(user);
          }
          
          return reply(Boom.notFound());
        });
    }
});

server.start((err) => {

    if (err) {
        throw err;
    }
    console.log(`Server running at: ${server.info.uri}`);
});
