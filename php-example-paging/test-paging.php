<?php

$total_elements = 100;

$idx_last_element_string = $_GET['idx_last_element'];
$block_size_paging_string = $_GET['block_size_paging'];
$idx_last_element = intval($idx_last_element_string);
$block_size_paging = intval($block_size_paging_string);
$total_page = round($total_elements/$block_size_paging);

$total_array = array();

for ($i=0;$i<$total_elements;$i++){
	$arr["id"] = $i;
	$arr["name"] = "titolo".$i;
	$arr["description"] = "description".$i;
	array_push($total_array,$arr);
}


$dictionary["idx_last_element"] = $idx_last_element;
$dictionary["total_pages"] = $total_page;

/*
$total_array = array(
		array(
			"id" => "1",
			"name" => "Titolo1",
			"description" => "Description1"
		),
		array(
			"id" => "2",
			"name" => "Titolo2",
			"description" => "Description2"
		),
		array(
			"id" => "3",
			"name" => "Titolo3",
			"description" => "Description3"
		),
		array(
			"id" => "4",
			"name" => "Titolo4",
			"description" => "Description4"
		),
		array(
			"id" => "5",
			"name" => "Titolo5",
			"description" => "Description5"
		),
		array(
			"id" => "6",
			"name" => "Titolo6",
			"description" => "Description6"
		),
		array(
			"id" => "7",
			"name" => "Titolo7",
			"description" => "Description7"
		),
		array(
			"id" => "8",
			"name" => "Titolo8",
			"description" => "Description8"
		),
		array(
			"id" => "9",
			"name" => "Titolo9",
			"description" => "Description9"
		),
		array(
			"id" => "10",
			"name" => "Titolo10",
			"description" => "Description10"
		),
		array(
			"id" => "11",
			"name" => "Titolo11",
			"description" => "Description11"
		),
		array(
			"id" => "12",
			"name" => "Titolo12",
			"description" => "Description12"
		),
);
*/


$index_inf = $idx_last_element;
$total_array = array_slice($total_array, $index_inf, $block_size_paging, false);

$dictionary["current_page"] = $total_page-round(intval(($total_elements-$idx_last_element)/$block_size_paging));
$dictionary["objects"] = $total_array;
$json = json_encode($dictionary);


	echo $json;

?>