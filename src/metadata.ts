/* eslint-disable */
export default async () => {
    const t = {};
    return { "@nestjs/swagger": { "models": [[import("./common/dto/pagination-query.dto"), { "PaginationQueryDto": { limit: { required: true, type: () => Number, minimum: 1 }, offset: { required: true, type: () => Number, minimum: 1 } } }], [import("./events/entities/event.entity"), { "Event": { id: { required: true, type: () => Number }, type: { required: true, type: () => String }, name: { required: true, type: () => String }, payload: { required: true, type: () => Object } } }]], "controllers": [[import("./app.controller"), { "AppController": { "getHello": { type: String } } }]] } };
};