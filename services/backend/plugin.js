// Copyright (c) 2026 World Class Scholars, led by Dr Christopher Appiah-Thompson. All rights reserved.

import cors from '@fastify/cors';
import rateLimit from '@fastify/rate-limit';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export default async function (fastify) {
	// Enable CORS for trusted origins (adjust origin as needed)
	fastify.register(cors, {
		origin: [
			'http://localhost:3000', // frontend dev
			'http://localhost:5173', // Vite dev
			'https://your-production-domain.com' // production
		],
		credentials: true
	});

	// Rate limiting: 100 requests per minute per IP
	fastify.register(rateLimit, {
		max: 100,
		timeWindow: '1 minute'
	});


	// /api/generate-image
	fastify.post('/api/generate-image', {
		config: { rateLimit: { max: 10, timeWindow: '1 minute' } },
		schema: {
			body: {
				type: 'object',
				required: ['prompt'],
				properties: {
					prompt: { type: 'string', minLength: 1 },
					provider: { type: 'string', enum: ['openai', 'stablediffusion', 'honeygen'], default: 'openai' },
					output_format: { type: 'string', default: 'jpeg' }
				}
			},
			response: {
				200: {
					type: 'object',
					properties: {
						imageUrl: { type: 'string' },
						imageBase64: { type: 'string' },
						format: { type: 'string' }
					},
					additionalProperties: true
				},
				400: { type: 'object', properties: { error: { type: 'string' } } },
				500: { type: 'object', properties: { error: { type: 'string' } } }
			}
		}
	}, async (request, reply) => {
		// Placeholder: Integrate with OpenAI/Stability/Honeygen APIs as needed
		const { prompt, provider, output_format } = request.body;
		// Save the request to DB (simulate image generation)
		const image = await prisma.image.create({
			data: {
				prompt,
				imageUrl: 'https://example.com/image.jpg',
				provider,
				format: output_format
			}
		});
		return { imageUrl: image.imageUrl, format: image.format };
	});

	// /api/contact
	fastify.post('/api/contact', {
		config: { rateLimit: { max: 5, timeWindow: '1 minute' } },
		schema: {
			body: {
				type: 'object',
				required: ['name', 'email', 'message'],
				properties: {
					name: { type: 'string', minLength: 1 },
					email: { type: 'string', format: 'email' },
					message: { type: 'string', minLength: 1 },
					_gotcha: { type: 'string' }
				}
			},
			response: {
				200: { type: 'object', properties: { success: { type: 'boolean' } } },
				400: { type: 'object', properties: { error: { type: 'string' } } }
			}
		}
	}, async (request, reply) => {
		const { name, email, message, _gotcha } = request.body;
		if (_gotcha) return { success: true };
		await prisma.contact.create({ data: { name, email, message } });
		return { success: true };
	});

	// /api/images
	fastify.get('/api/images', {
		config: { rateLimit: { max: 20, timeWindow: '1 minute' } },
		schema: {
			response: {
				200: {
					type: 'array',
					items: {
						type: 'object',
						properties: {
							id: { type: 'number' },
							prompt: { type: 'string' },
							imageUrl: { type: 'string' },
							provider: { type: 'string' },
							format: { type: 'string' },
							created: { type: 'string', format: 'date-time' }
						}
					}
				}
			}
		}
	}, async (request, reply) => {
		const images = await prisma.image.findMany({ orderBy: { created: 'desc' }, take: 50 });
		return images;
	});

	fastify.post('/api/images', {
		config: { rateLimit: { max: 10, timeWindow: '1 minute' } },
		schema: {
			body: {
				type: 'object',
				required: ['prompt', 'imageUrl'],
				properties: {
					prompt: { type: 'string', minLength: 1 },
					imageUrl: { type: 'string', minLength: 1 },
					provider: { type: 'string' },
					format: { type: 'string' }
				}
			},
			response: {
				200: { type: 'object', properties: { success: { type: 'boolean' } } },
				400: { type: 'object', properties: { error: { type: 'string' } } }
			}
		}
	}, async (request, reply) => {
		const { prompt, imageUrl, provider, format } = request.body;
		await prisma.image.create({ data: { prompt, imageUrl, provider, format } });
		return { success: true };
	});
}