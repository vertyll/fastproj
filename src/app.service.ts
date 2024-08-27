import { Injectable } from '@nestjs/common';
import { HelloResponse } from './shared/types/app.types';

@Injectable()
export class AppService {
  getHello(): HelloResponse {
    return { message: 'Hello World!' };
  }
}
