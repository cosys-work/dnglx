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

/**
 * @export
 * @interface User
 */
export interface User {
    /**
     * @type {number}
     * @memberof User
     */
    id?: number;
    /**
     * @type {string}
     * @memberof User
     */
    username?: string;
    /**
     * @type {string}
     * @memberof User
     */
    firstName?: string;
    /**
     * @type {string}
     * @memberof User
     */
    lastName?: string;
    /**
     * @type {string}
     * @memberof User
     */
    email?: string;
    /**
     * @type {string}
     * @memberof User
     */
    password?: string;
    /**
     * @type {string}
     * @memberof User
     */
    phone?: string;
    /**
     * User Status
     * @type {number}
     * @memberof User
     */
    userStatus?: number;
}
