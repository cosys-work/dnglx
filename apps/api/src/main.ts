/**
 * This is not a production server yet!
 * This is only a minimal backend to get started.
 */

import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';

import { AppModule } from './app/app.module';
import {FastifyAdapter, NestFastifyApplication} from "@nestjs/platform-fastify";

import compression from 'fastify-compress';
import { fastifyHelmet } from 'fastify-helmet';
import fastifyCsrf from 'fastify-csrf';
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";

async function bootstrap() {
  const app = await NestFactory.create<NestFastifyApplication>(
    AppModule,
    new FastifyAdapter()
  );
  const globalPrefix = 'api';
  app.setGlobalPrefix(globalPrefix);
  const port = process.env.PORT || 3333;
  app.enableCors();

  const config = new DocumentBuilder()
    .setTitle('PROX E|G')
    .setDescription('The prox-e|g APIs as described on risav.dev')
    .setVersion('1.0')
    .addTag('proxies')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup(globalPrefix, app, document);

  await app.register(fastifyCsrf);
  await app.register(compression, { encodings: ['gzip', 'deflate'] });
  await app.register(fastifyHelmet);


  await app.listen(port, () => {
    Logger.log('Listening at http://localhost:' + port + '/' + globalPrefix);
  });
}

bootstrap();
