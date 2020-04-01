<?php
// #6 https://github.com/janis-rullis/dzhim-cms/blob/master/pub/index.php
define('__root', dirname($_SERVER['DOCUMENT_ROOT']));
define('__baseUrl', 'https://' . $_SERVER['HTTP_HOST']);
require_once __root . '/.env.php';
//setErrorReporting();

try {
	$request = new Request();
	$request->redirect();
} catch (Exception $ex) {
	die($ex->getMessage());
}

class Request
{

	public $url;
	public $uri;

	function __construct()
	{
		$this->uri = filter_var($_SERVER['REQUEST_URI'], FILTER_SANITIZE_STRING);
		$this->url = __baseUrl . '' . $this->uri;
	}

	/**
	 * #6 Redirect to the URL defined in the database from the current URI.
	 * 
	 * @return void
	 * @throws Exception
	 */
	function redirect(): void
	{
		$this->validate();

		// #6 https://stackoverflow.com/a/35319119
		$pdo = new DbClass();
		$conn = $pdo->getConnection();
		$stmt = $conn->prepare("
				SELECT `to`
				FROM `redirect` 
				WHERE `from` = :from	
				AND `is_public` = :is_public
				LIMIT 1;");
		$stmt->execute([':from' => $this->uri, ':is_public' => 'y']);
		$to = $stmt->fetch()[0];
		if (!$to) {
			throw new \Exception('Invalid request.');
		}

		redirect($to);
	}

	function validate(): void
	{
		$this->validateUri();
	}

	/**
	 * #6 Validate the URI.
	 * 
	 * @param string $uri
	 * @return void
	 * @throws Exception
	 */
	function validateUri(string $uri = ''): void
	{
		$uri = empty($uri) ? $this->uri : $uri;
		if (!$this->isValidUri($uri)) {
			throw new \Exception('Invalid URL.');
		}
	}

	/**
	 * #6 Is URL valid?
	 * 
	 * @param string $uri
	 * @return bool
	 */
	function isValidUri(string $uri): bool
	{
		// #6 https://stackoverflow.com/a/42558914
		return preg_match('/^[A-Za-z0-9-\\/]+$/D', $uri);
	}
}

/**
 * Shorthand for print and die.
 * 
 * @param type $data
 * @return void
 */
function dd($data): void
{
	var_dump($data);
	exit;
}

/**
 * #6 Enable the error reporting for debugging.
 * https://github.com/janis-rullis/dzhim-cms/blob/master/fmw/core/fn.php
 * 
 * @return void
 */
function setErrorReporting(): void
{
	error_reporting(E_ALL);
	ini_set('display_errors', TRUE);
	ini_set('display_startup_errors', TRUE);
}

/**
 * #6 Redirect to URl.
 * https://github.com/janis-rullis/dzhim-cms/blob/94dee8d8a41983415f1977e6c80ab4ee59f5e6b9/fmw/core/mod/cat_settings/out/module.php
 * 
 * @param string $url
 * @return void
 */
function redirect(string $url): void
{
	header('Location: ' . $url);
	exit();
}
