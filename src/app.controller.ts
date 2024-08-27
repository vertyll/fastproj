import { Controller, Get, Render } from '@nestjs/common';
import { AppService } from './app.service';
import { HelloResponse } from './shared/types/app.types';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  @Render('index')
  getHello(): HelloResponse {
    return this.appService.getHello();
  }
}
