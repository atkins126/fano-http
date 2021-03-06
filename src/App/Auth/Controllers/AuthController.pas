(*!------------------------------------------------------------
 * [[APP_NAME]] ([[APP_URL]])
 *
 * @link      [[APP_REPOSITORY_URL]]
 * @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]
 * @license   [[LICENSE_URL]] ([[LICENSE]])
 *------------------------------------------------------------- *)
unit AuthController;

interface

{$MODE OBJFPC}
{$H+}

uses

    fano;

type

    (*!-----------------------------------------------
     * controller that handle route :
     * /auth
     *
     * See Routes/Auth/routes.inc
     *
     * @author [[AUTHOR_NAME]] <[[AUTHOR_EMAIL]]>
     *------------------------------------------------*)
    TAuthController = class(TAbstractController)
    public
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader
        ) : IResponse; override;
    end;

implementation

uses

    sysutils;

    function TAuthController.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader
    ) : IResponse;
    var
        postParams : IReadOnlyList;
        i, j : integer;
        keyName : string;
        respBody : IResponseStream;
        uploadFiles : IUploadedFileArray;
    begin
        respBody := response.body();
        respBody.write('<html><head><title>Auth controller</title></head><body>');
        respBody.write('<h1>Auth controller</h1>');
        respBody.write('<ul>');
        postParams := request.parsedBodyParams;
        for i := 0 to postParams.count() - 1 do
        begin
            keyName := postParams.keyOfIndex(i);
            respBody.write(
                format(
                    '<li>%s=%s</li>',
                    [
                        keyName,
                        request.getParsedBodyParam(keyName)
                    ])
            );
        end;
        respBody.write('</ul>');

        respBody.write('<ul>');
        for i:= 0 to request.uploadedFiles.count() - 1 do
        begin
            uploadFiles := request.uploadedFiles.getUploadedFile(i);
            for j:=0  to length(uploadFiles) - 1 do
            begin
                uploadFiles[j].moveTo(
                    GetCurrentDir() + '/storages/uploads/' + uploadFiles[j].getClientFilename()
                );
                respBody.write('<li>' + uploadFiles[j].getClientFilename() + '</li>');
            end;
        end;
        respBody.write('</ul>');
        respBody.write('</body></html>');

        result := response;
    end;

end.
