import { Injectable } from '@nestjs/common';
import { Message } from '@cosys-work/api-interfaces';

@Injectable()
export class AppService {
  getData(): Message {
    return { message: 'Welcome to Nest API!' };
  }
}
