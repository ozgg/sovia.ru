<?php
class Ext_Helper_Image
{
	public static function copyresized($filePath, array $options = array())
	{
		/**
		 * Ширина и высота нового файла.
		 */
		$nw = 100;
		$nh = 100;
		if (isset($options['width'])) {
			$nw = abs($options['width']);
		}
		if (isset($options['height'])) {
			$nh = abs($options['height']);
		}
		if (isset($options['destination'])) {
			$destination = $options['destination'];
		} else {
			$destination = $filePath;
		}
		if (isset($options['imagesize'])) {
			$imagesize = $options['imagesize'];
		} else {
			$imagesize = getimagesize($filePath);
		}
		$image  = null;
		$spawn  = null;
		$target = null;
		switch ($imagesize[2]) {
			case IMAGETYPE_GIF:
				$image = imagecreatefromgif($filePath);
				$spawn = 'imagegif';
				$target = imagecreate($nw, $nh);
				break;
			case IMAGETYPE_PNG:
				$image  = imagecreatefrompng($filePath);
				$spawn  = 'imagepng';
				$target = imagecreatetruecolor($nw, $nh);
				break;
			case IMAGETYPE_JPEG:
			case IMAGETYPE_JPC:
			case IMAGETYPE_JP2:
			case IMAGETYPE_JPX:
			case IMAGETYPE_JPEG2000:
				$image  = imagecreatefromjpeg($filePath);
				$spawn  = 'imagejpeg';
				$target = imagecreatetruecolor($nw, $nh);
				break;
			default:
				throw new Exception('Недопустимый формат файла.');
		}
		$fileIsCopied = false;
		if (!empty($image) && function_exists($spawn) && !empty($target)) {
			$w = $imagesize[0];
			$h = $imagesize[1];
			if (imagecopyresized($target, $image, 0, 0, 0, 0, $nw, $nh, $w, $h)) {
				if ($spawn($target, $destination)) {
					$fileIsCopied = true;
				} else {
					throw new Exception('Ошибка сохранения файла.');
				}
			} else {
				throw new Exception('Ошибка преобразования файла.');
			}
			unset($w, $h);
			imagedestroy($image);
			imagedestroy($target);
		} else {
			throw new Exception("Ошибка файла или нет функции {$spawn}().");
		}
		unset($nw, $nh, $spawn, $imagesize, $destination);
		return $fileIsCopied;
	}
	
	public static function getAllowedTypes()
	{
		return array(
			IMAGETYPE_GIF  => 'gif',
			IMAGETYPE_PNG  => 'png',
			IMAGETYPE_JPEG => 'jpg',
			IMAGETYPE_JPC  => 'jpg',
			IMAGETYPE_JP2  => 'jpg',
			IMAGETYPE_JPX  => 'jpg',
			IMAGETYPE_JPEG2000 => 'jpg',
		);
	}
}
?>