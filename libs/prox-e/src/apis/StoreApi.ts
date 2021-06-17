// tslint:disable
/**
 * Swagger Petstore
 * This is a sample server Petstore server.  You can find out more about     Swagger at [http://swagger.io](http://swagger.io) or on [irc.freenode.net, #swagger](http://swagger.io/irc/).      For this sample, you can use the api key `special-key` to test the authorization     filters.
 *
 * The version of the OpenAPI document: 1.0.0
 * Contact: apiteam@swagger.io
 *
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */

import { Observable } from 'rxjs';
import { BaseAPI, HttpHeaders, throwIfNullOrUndefined, encodeURI, OperationOpts, RawAjaxResponse } from '../runtime';
import {
    Order,
} from '../models';

export interface DeleteOrderRequest {
    orderId: number;
}

export interface GetOrderByIdRequest {
    orderId: number;
}

export interface PlaceOrderRequest {
    body: Order;
}

/**
 * no description
 */
export class StoreApi extends BaseAPI {

    /**
     * For valid response try integer IDs with positive integer value.         Negative or non-integer values will generate API errors
     * Delete purchase order by ID
     */
    deleteOrder({ orderId }: DeleteOrderRequest): Observable<void>
    deleteOrder({ orderId }: DeleteOrderRequest, opts?: OperationOpts): Observable<void | RawAjaxResponse<void>>
    deleteOrder({ orderId }: DeleteOrderRequest, opts?: OperationOpts): Observable<void | RawAjaxResponse<void>> {
        throwIfNullOrUndefined(orderId, 'orderId', 'deleteOrder');

        return this.request<void>({
            url: '/store/order/{orderId}'.replace('{orderId}', encodeURI(orderId)),
            method: 'DELETE',
        }, opts?.responseOpts);
    };

    /**
     * Returns a map of status codes to quantities
     * Returns pet inventories by status
     */
    getInventory(): Observable<{ [key: string]: number; }>
    getInventory(opts?: OperationOpts): Observable<RawAjaxResponse<{ [key: string]: number; }>>
    getInventory(opts?: OperationOpts): Observable<{ [key: string]: number; } | RawAjaxResponse<{ [key: string]: number; }>> {
        const headers: HttpHeaders = {
            ...(this.configuration.apiKey && { 'api_key': this.configuration.apiKey('api_key') }), // api_key authentication
        };

        return this.request<{ [key: string]: number; }>({
            url: '/store/inventory',
            method: 'GET',
            headers,
        }, opts?.responseOpts);
    };

    /**
     * For valid response try integer IDs with value >= 1 and <= 10.         Other values will generated exceptions
     * Find purchase order by ID
     */
    getOrderById({ orderId }: GetOrderByIdRequest): Observable<Order>
    getOrderById({ orderId }: GetOrderByIdRequest, opts?: OperationOpts): Observable<RawAjaxResponse<Order>>
    getOrderById({ orderId }: GetOrderByIdRequest, opts?: OperationOpts): Observable<Order | RawAjaxResponse<Order>> {
        throwIfNullOrUndefined(orderId, 'orderId', 'getOrderById');

        return this.request<Order>({
            url: '/store/order/{orderId}'.replace('{orderId}', encodeURI(orderId)),
            method: 'GET',
        }, opts?.responseOpts);
    };

    /**
     * Place an order for a pet
     */
    placeOrder({ body }: PlaceOrderRequest): Observable<Order>
    placeOrder({ body }: PlaceOrderRequest, opts?: OperationOpts): Observable<RawAjaxResponse<Order>>
    placeOrder({ body }: PlaceOrderRequest, opts?: OperationOpts): Observable<Order | RawAjaxResponse<Order>> {
        throwIfNullOrUndefined(body, 'body', 'placeOrder');

        const headers: HttpHeaders = {
            'Content-Type': 'application/json',
        };

        return this.request<Order>({
            url: '/store/order',
            method: 'POST',
            headers,
            body: body,
        }, opts?.responseOpts);
    };

}
