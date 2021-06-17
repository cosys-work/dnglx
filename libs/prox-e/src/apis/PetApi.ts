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
import { BaseAPI, HttpHeaders, HttpQuery, throwIfNullOrUndefined, encodeURI, OperationOpts, RawAjaxResponse } from '../runtime';
import {
    ApiResponse,
    Pet,
} from '../models';

export interface AddPetRequest {
    body: Pet;
}

export interface DeletePetRequest {
    petId: number;
    apiKey?: string;
}

export interface FindPetsByStatusRequest {
    status: Array<FindPetsByStatusStatusEnum>;
}

export interface FindPetsByTagsRequest {
    tags: Array<string>;
}

export interface GetPetByIdRequest {
    petId: number;
}

export interface UpdatePetRequest {
    body: Pet;
}

export interface UpdatePetWithFormRequest {
    petId: number;
    name?: string;
    status?: string;
}

export interface UploadFileRequest {
    petId: number;
    additionalMetadata?: string;
    file?: Blob;
}

/**
 * no description
 */
export class PetApi extends BaseAPI {

    /**
     * Add a new pet to the store
     */
    addPet({ body }: AddPetRequest): Observable<void>
    addPet({ body }: AddPetRequest, opts?: OperationOpts): Observable<void | RawAjaxResponse<void>>
    addPet({ body }: AddPetRequest, opts?: OperationOpts): Observable<void | RawAjaxResponse<void>> {
        throwIfNullOrUndefined(body, 'body', 'addPet');

        const headers: HttpHeaders = {
            'Content-Type': 'application/json',
            // oauth required
            ...(this.configuration.accessToken != null
                ? { Authorization: typeof this.configuration.accessToken === 'function'
                    ? this.configuration.accessToken('petstore_auth', ['write:pets', 'read:pets'])
                    : this.configuration.accessToken }
                : undefined
            ),
        };

        return this.request<void>({
            url: '/pet',
            method: 'POST',
            headers,
            body: body,
        }, opts?.responseOpts);
    };

    /**
     * Deletes a pet
     */
    deletePet({ petId, apiKey }: DeletePetRequest): Observable<void>
    deletePet({ petId, apiKey }: DeletePetRequest, opts?: OperationOpts): Observable<void | RawAjaxResponse<void>>
    deletePet({ petId, apiKey }: DeletePetRequest, opts?: OperationOpts): Observable<void | RawAjaxResponse<void>> {
        throwIfNullOrUndefined(petId, 'petId', 'deletePet');

        const headers: HttpHeaders = {
            ...(apiKey != null ? { 'api_key': String(apiKey) } : undefined),
            // oauth required
            ...(this.configuration.accessToken != null
                ? { Authorization: typeof this.configuration.accessToken === 'function'
                    ? this.configuration.accessToken('petstore_auth', ['write:pets', 'read:pets'])
                    : this.configuration.accessToken }
                : undefined
            ),
        };

        return this.request<void>({
            url: '/pet/{petId}'.replace('{petId}', encodeURI(petId)),
            method: 'DELETE',
            headers,
        }, opts?.responseOpts);
    };

    /**
     * Multiple status values can be provided with comma separated strings
     * Finds Pets by status
     */
    findPetsByStatus({ status }: FindPetsByStatusRequest): Observable<Array<Pet>>
    findPetsByStatus({ status }: FindPetsByStatusRequest, opts?: OperationOpts): Observable<RawAjaxResponse<Array<Pet>>>
    findPetsByStatus({ status }: FindPetsByStatusRequest, opts?: OperationOpts): Observable<Array<Pet> | RawAjaxResponse<Array<Pet>>> {
        throwIfNullOrUndefined(status, 'status', 'findPetsByStatus');

        const headers: HttpHeaders = {
            // oauth required
            ...(this.configuration.accessToken != null
                ? { Authorization: typeof this.configuration.accessToken === 'function'
                    ? this.configuration.accessToken('petstore_auth', ['write:pets', 'read:pets'])
                    : this.configuration.accessToken }
                : undefined
            ),
        };

        const query: HttpQuery = { // required parameters are used directly since they are already checked by throwIfNullOrUndefined
            'status': status,
        };

        return this.request<Array<Pet>>({
            url: '/pet/findByStatus',
            method: 'GET',
            headers,
            query,
        }, opts?.responseOpts);
    };

    /**
     * Muliple tags can be provided with comma separated strings. Use         tag1, tag2, tag3 for testing.
     * Finds Pets by tags
     */
    findPetsByTags({ tags }: FindPetsByTagsRequest): Observable<Array<Pet>>
    findPetsByTags({ tags }: FindPetsByTagsRequest, opts?: OperationOpts): Observable<RawAjaxResponse<Array<Pet>>>
    findPetsByTags({ tags }: FindPetsByTagsRequest, opts?: OperationOpts): Observable<Array<Pet> | RawAjaxResponse<Array<Pet>>> {
        throwIfNullOrUndefined(tags, 'tags', 'findPetsByTags');

        const headers: HttpHeaders = {
            // oauth required
            ...(this.configuration.accessToken != null
                ? { Authorization: typeof this.configuration.accessToken === 'function'
                    ? this.configuration.accessToken('petstore_auth', ['write:pets', 'read:pets'])
                    : this.configuration.accessToken }
                : undefined
            ),
        };

        const query: HttpQuery = { // required parameters are used directly since they are already checked by throwIfNullOrUndefined
            'tags': tags,
        };

        return this.request<Array<Pet>>({
            url: '/pet/findByTags',
            method: 'GET',
            headers,
            query,
        }, opts?.responseOpts);
    };

    /**
     * Returns a single pet
     * Find pet by ID
     */
    getPetById({ petId }: GetPetByIdRequest): Observable<Pet>
    getPetById({ petId }: GetPetByIdRequest, opts?: OperationOpts): Observable<RawAjaxResponse<Pet>>
    getPetById({ petId }: GetPetByIdRequest, opts?: OperationOpts): Observable<Pet | RawAjaxResponse<Pet>> {
        throwIfNullOrUndefined(petId, 'petId', 'getPetById');

        const headers: HttpHeaders = {
            ...(this.configuration.apiKey && { 'api_key': this.configuration.apiKey('api_key') }), // api_key authentication
        };

        return this.request<Pet>({
            url: '/pet/{petId}'.replace('{petId}', encodeURI(petId)),
            method: 'GET',
            headers,
        }, opts?.responseOpts);
    };

    /**
     * Update an existing pet
     */
    updatePet({ body }: UpdatePetRequest): Observable<void>
    updatePet({ body }: UpdatePetRequest, opts?: OperationOpts): Observable<void | RawAjaxResponse<void>>
    updatePet({ body }: UpdatePetRequest, opts?: OperationOpts): Observable<void | RawAjaxResponse<void>> {
        throwIfNullOrUndefined(body, 'body', 'updatePet');

        const headers: HttpHeaders = {
            'Content-Type': 'application/json',
            // oauth required
            ...(this.configuration.accessToken != null
                ? { Authorization: typeof this.configuration.accessToken === 'function'
                    ? this.configuration.accessToken('petstore_auth', ['write:pets', 'read:pets'])
                    : this.configuration.accessToken }
                : undefined
            ),
        };

        return this.request<void>({
            url: '/pet',
            method: 'PUT',
            headers,
            body: body,
        }, opts?.responseOpts);
    };

    /**
     * Updates a pet in the store with form data
     */
    updatePetWithForm({ petId, name, status }: UpdatePetWithFormRequest): Observable<void>
    updatePetWithForm({ petId, name, status }: UpdatePetWithFormRequest, opts?: OperationOpts): Observable<void | RawAjaxResponse<void>>
    updatePetWithForm({ petId, name, status }: UpdatePetWithFormRequest, opts?: OperationOpts): Observable<void | RawAjaxResponse<void>> {
        throwIfNullOrUndefined(petId, 'petId', 'updatePetWithForm');

        const headers: HttpHeaders = {
            // oauth required
            ...(this.configuration.accessToken != null
                ? { Authorization: typeof this.configuration.accessToken === 'function'
                    ? this.configuration.accessToken('petstore_auth', ['write:pets', 'read:pets'])
                    : this.configuration.accessToken }
                : undefined
            ),
        };

        const formData = new FormData();
        if (name !== undefined) { formData.append('name', name as any); }
        if (status !== undefined) { formData.append('status', status as any); }

        return this.request<void>({
            url: '/pet/{petId}'.replace('{petId}', encodeURI(petId)),
            method: 'POST',
            headers,
            body: formData,
        }, opts?.responseOpts);
    };

    /**
     * uploads an image
     */
    uploadFile({ petId, additionalMetadata, file }: UploadFileRequest): Observable<ApiResponse>
    uploadFile({ petId, additionalMetadata, file }: UploadFileRequest, opts?: OperationOpts): Observable<RawAjaxResponse<ApiResponse>>
    uploadFile({ petId, additionalMetadata, file }: UploadFileRequest, opts?: OperationOpts): Observable<ApiResponse | RawAjaxResponse<ApiResponse>> {
        throwIfNullOrUndefined(petId, 'petId', 'uploadFile');

        const headers: HttpHeaders = {
            // oauth required
            ...(this.configuration.accessToken != null
                ? { Authorization: typeof this.configuration.accessToken === 'function'
                    ? this.configuration.accessToken('petstore_auth', ['write:pets', 'read:pets'])
                    : this.configuration.accessToken }
                : undefined
            ),
        };

        const formData = new FormData();
        if (additionalMetadata !== undefined) { formData.append('additionalMetadata', additionalMetadata as any); }
        if (file !== undefined) { formData.append('file', file as any); }

        return this.request<ApiResponse>({
            url: '/pet/{petId}/uploadImage'.replace('{petId}', encodeURI(petId)),
            method: 'POST',
            headers,
            body: formData,
        }, opts?.responseOpts);
    };

}

/**
 * @export
 * @enum {string}
 */
export enum FindPetsByStatusStatusEnum {
    Available = 'available',
    Pending = 'pending',
    Sold = 'sold'
}
