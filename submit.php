<?php
    require_once("db.php");
	// UGLY PROTOTYPE 
	$mysql = null;
    

	class MissionData {
		public $title;
		public $agent;
		public $details;
		public $reward;
		public $bonus_details;
		public $bonus_reward;

		private $_requiredFields = array(
				'title',
				'agent',
				'details',
				'reward'
			);

		public function build($POST) {

			// Make sure each field is valid
			foreach($this->_requiredFields as $key) {
				if(!isset($POST[$key]) /*&& !empty($POST[$key])*/) {
					return false;
				}
			}

			$this->title = htmlspecialchars($POST['title']);
			$this->agent = htmlspecialchars($POST['agent']);
			$this->details = htmlspecialchars($POST['details']);
			$this->reward = htmlspecialchars($POST['reward']);
			$this->bonus_details = htmlspecialchars($POST['bonusdetails']);
			$this->bonus_reward = htmlspecialchars($POST['bonusreward']);

			return true;
		}
	}

	function connectToDB() {
        $database = null;
        $database = new PDO('mysql:host=127.0.0.1;dbname=DB_NAME;charset=utf8', DB_USER, DB_PASS);
        return $database;
}

	function insertData($sql, $data) {
        $statement = $sql->prepare("INSERT INTO missions(name, details, agent, reward, bonusDetails, bonusReward) VALUES (:title, :details, :agent, :reward, :bonus_details, :bonus_reward)");
		$success = $statement->execute(array(
				"title" => $data->title, 
				"agent" => $data->agent,
				"details" => $data->details,
				"reward" => $data->reward,
				"bonus_details" => $data->bonus_details,
				"bonus_reward" => $data->bonus_reward));
	}

	if($_POST) {
		$missiondata =  new MissionData();

		if(!$missiondata->build($_POST)) {
			echo "FAILED to validate. Data missing from form<br />";
		} else {

			$mysql = connectToDB();
			if($mysql != null) {
				insertData($mysql, $missiondata);
			}


		}
        
	}
    header("Location: submit.html"); 
?>