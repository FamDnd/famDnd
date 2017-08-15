<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require_once(APPPATH . 'classes/Httperrorexception.php');

/**
 * Wrapper on CI_Controller to set common settings that apply to all controllers
 */
class MY_Controller extends CI_Controller {

    protected $tempData = array();

    public function __construct() {

        parent::__construct();

        // Important: Set the default headers for all responses to
        // - prevent page caching
        // - prevent preventClickJacking
        header("Cache-Control: no-cache, max-age=0, must-revalidate, no-store");  // HTTP 1.1.
        header("Pragma: no-cache");  // HTTP 1.0.
        header("Expires: 0");  // Proxies.

        // Default init the timezone to EDT
        $this->setTimezone("America/Toronto");

        // Uncomment the line below to increase the memory limit
        // ini_set('memory_limit', '512M');
    }

    protected function getTempData() {

        return $this->tempData;
    }

    // -- Misc.

    protected function throwInvalidDataError() {

        throw new HttpClientErrorException(
            lang('error_invalid_data'),
            HTTP_STATUS_CODE_BAD_REQUEST
        );
    }
}

trait Xsrf {

    protected function setXsrfToken() {

        // Set the XSRF-TOKEN cookie on the first GET request
        if (!isset($_COOKIE['XSRF-TOKEN']) && strtolower($_SERVER['REQUEST_METHOD']) === 'get') {

            $xsrfToken = md5(uniqid(rand(), true));

            // Set the XSRF-TOKEN cookie.
            // The cookie has a lifespan of a single session (we also clear the cookie when the user
            // logs out).
            // The cookie will only be sent to the server if there is a secure HTTPS connection
            // (production only).
            // The cookie will be accessible via Javascript (httponly is false).
            // Note: $this->input->set_cookie will detect the system configuration for the secure
            // and httponly settings, so we are using setcookie() instead.
            setcookie(
                'XSRF-TOKEN',
                $xsrfToken,
                0,
                $this->config->item('cookie_path'),
                $this->config->item('cookie_domain'),
                $this->config->item('cookie_secure'),
                false
            );
        }
    }

    protected function checkXsrfToken() {

        if (!in_array(
                strtolower($_SERVER['REQUEST_METHOD']),
                array('get', 'head', 'options', 'trace')
            )) {

            $this->verifyXsrfToken();
        }
    }

    private function verifyXsrfToken() {

        // We are using Double Submit Cookies to prevent CSRF.
        // See https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF)_Prevention_Cheat_Sheet
        // for more details.

        try {

            if (!isset($_COOKIE['XSRF-TOKEN'])) {
                throw new HttpClientErrorException(
                    "Bad Request: Missing XSRF-TOKEN cookie",
                    HTTP_STATUS_CODE_BAD_REQUEST
                );
            }

            // Check for a X-XSRF-TOKEN HTTP header.
            $requestXsrfToken = getOrElse($_SERVER, 'HTTP_X_XSRF_TOKEN', null);

            // no X-XSRF-TOKEN header?
            if ($requestXsrfToken === NULL) {

                // fallback to $_POST['X-XSRF-TOKEN']
                $requestXsrfToken = getOrElse($_POST, 'HTTP_X_XSRF_TOKEN', null);

                if ($requestXsrfToken === NULL) {
                    throw new HttpClientErrorException(
                        "Bad Request: Missing XSRF token",
                        HTTP_STATUS_CODE_BAD_REQUEST
                    );
                }
            }

            // Verify request value and the cookie value are equal.
            if ($requestXsrfToken !== $_COOKIE['XSRF-TOKEN']) {
                throw new HttpClientErrorException(
                    "Forbidden: Invalid XSRF token",
                    HTTP_STATUS_CODE_FORBIDDEN
                );
            }

        } catch (HttpErrorException $e) {
            httpError($e->getCode(), $e->getMessage());
        } catch (Exception $e) {
            httpError(
                HTTP_STATUS_CODE_INTERNAL_SERVER_ERROR,
                "Internal Server Error. Please try again or contact Support@GoBonfire.com."
            );
        }
    }
}
