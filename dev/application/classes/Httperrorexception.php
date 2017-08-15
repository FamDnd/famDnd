<?php if (! defined('BASEPATH')) exit('No direct script access allowed');

if (!class_exists('HttpErrorException')) {

    abstract class HttpErrorException extends Exception implements JsonSerializable {

        public function __construct($message, $httpStatusCode, Exception $previous = null) {

            parent::__construct($message, $httpStatusCode, $previous);
        }

        public function jsonSerialize() {

            return $this->__toString();
        }
    }

    class HttpClientErrorException extends HttpErrorException {

        public function __construct($message = "Client Error", $httpStatusCode = 400, Exception $previous = null) {

            parent::__construct($message, $httpStatusCode, $previous);
        }
    }

    class HttpServerErrorException extends HttpErrorException {

        public function __construct($message = "Internal Server Error. Please try again or contact Support@GoBonfire.com.", $httpStatusCode = 500, Exception $previous = null) {

            parent::__construct($message, $httpStatusCode, $previous);
        }
    }
}
