import { ApiKeyGuard } from './api-key.guard';
import { Reflector } from '@nestjs/core';
import { ConfigService } from '@nestjs/config';

describe('ApiKeyGuard', () => {
  let apiKeyGuard: ApiKeyGuard;
  let reflector: Reflector;
  let configService: ConfigService;

  beforeEach(() => {
    reflector = new Reflector();
    configService = new ConfigService();

    apiKeyGuard = new ApiKeyGuard(reflector, configService);
  });

  it('should be defined', () => {
    expect(apiKeyGuard).toBeDefined();
  });
});
