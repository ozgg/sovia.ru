<?php
/**
 * 
 */

/**
 *
 */
class Default_Model_UserAvatar extends Default_Model_Ancestor
{
	protected $_id;
	protected $_ownerId;
	protected $_name;
	protected $_extension;

	const STORAGE = '/images/avatars/';
	const MAX_WIDTH  = 100;
	const MAX_HEIGHT = 100;
	const MAX_WEIGHT = 20480;

	public function __toString()
	{
		$image = '';
		$path  = $this->getFilepath();
		if (!empty($path)) {
			$file = '.' . self::STORAGE . $path;
			if (file_exists($file)) {
				$imageSize = getimagesize($file);
				if (!empty($imageSize[3])) {
					$name   = $this->getName();
					$image  = '<img src="' . self::STORAGE . $path . '"';
					$image .= $imageSize[3] . ' alt="' . $name . '" />';
					unset($name);
				}
			}
			unset($file);
		}
		unset($path);
		return $image;
	}
	
	/**
	 * Get data mapper
	 *
	 * Lazy loads Default_Model_UserAvatarMapper instance if no mapper registered.
	 * 
	 * @return Default_Model_UserAvatarMapper
	 */
	public function getMapper()
	{
		if (null === $this->_mapper) {
			$this->setMapper(new Default_Model_UserAvatarMapper());
		}
		return $this->_mapper;
	}

	public function getId()
	{
		return $this->_id;
	}

	public function setId($id)
	{
		$this->_id = intval($id);
		return $this;
	}

	public function getOwnerId()
	{
		return $this->_ownerId;
	}

	public function setOwnerId($ownerId)
	{
		$this->_ownerId = intval($ownerId);
		return $this;
	}

	public function getName($escape = true)
	{
		if ($escape) {
			$name = $this->_escape($this->_name);
		} else {
			$name = $this->_name;
		}
		return $name;
	}

	public function setName($name)
	{
		$this->_name = $name;
		return $this;
	}

	public function getFilepath()
	{
		$path  = floor($this->getId() / 1000);
		$path .= sprintf('/%x-%u', $this->getOwnerId(), $this->getId());
		$path .= ".{$this->getExtension()}";
		return $path;
	}

	public function getExtension()
	{
		return $this->_extension;
	}

	public function setExtension($extension)
	{
		$this->_extension = $extension;
		return $this;
	}
	
	public function getList($page = 1, $epp = 30, array $options = array())
	{
		return $this->getMapper()->getList($page, $epp, $options);
	}
	
	public function delete()
	{
		if ($this->getMapper()->delete($this->getId())) {
			$path  = $this->getFilepath();
			if (!empty($path)) {
				$file = '.' . self::STORAGE . $path;
				if (file_exists($file)) {
					unlink($file);
				} else {
					throw new Exception('Файл с картинкой не найден.');
				}
				unset($file);
			} else {
				throw new Exception('Не указан путь к файлу с картинкой.');
			}
			unset($path);
		}
	}
	
	public function getCountOf($userId)
	{
		settype($userId, 'int');
		return $this->getMapper()->getCountOf($userId);
	}
	
	public function setFile($filePath)
	{
		$imagesize = getimagesize($filePath);
		$allowed   = Ext_Helper_Image::getAllowedTypes();
		if (isset($imagesize[2], $allowed[$imagesize[2]])) {
			if (filesize($filePath) > self::MAX_WEIGHT) {
				$error = 'Размер файла превышает ' . self::MAX_WEIGHT . ' байт';
				throw new Exception($error);
			}
			if ($imagesize[0] > self::MAX_WIDTH * 10) {
				throw new Exception('Файл слишком большой.');
			}
			if ($imagesize[1] > self::MAX_HEIGHT * 10) {
				throw new Exception('Файл слишком большой.');
			}
			$extension = $allowed[$imagesize[2]];
			$this->setExtension($extension);
			$this->save();
			$format  = '.' . self::STORAGE . '/';
			$format .= floor($this->getId() / 1000) . '/%x-%d.';
			$dest  = sprintf($format, $this->getOwnerId(), $this->getId());
			$dest .= $extension;
			$options = array(
				'width'  => self::MAX_WIDTH,
				'height' => self::MAX_HEIGHT,
				'destination' => $dest,
				'imagesize'   => $imagesize,
			);
			$this->setExtension($extension);
			$this->save();
			Ext_Helper_Image::copyresized($filePath, $options);
//			unlink($filepath);
		} else {
			throw new Exception('Недопустимый тип файла');
		}
	}
}
?>