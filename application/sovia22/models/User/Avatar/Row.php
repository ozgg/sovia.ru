<?php
/**
 * Date: 14.01.12
 * Time: 1:50
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

class User_Avatar_Row extends Ext_Db_Table_Row
{
    public function __toString()
    {
        $image = '';
        $path  = $this->getFilePath();
        if (!empty($path)) {
            $file = '.' . User_Avatar::STORAGE . $path;
            if (file_exists($file)) {
                $imageSize = getimagesize($file);
                if (!empty($imageSize[3])) {
                    $name  = $this->getName();
                    $image = '<img src="' . User_Avatar::STORAGE . $path . '" ';
                    $image .= $imageSize[3] . ' alt="' . $name . '" />';
                    unset($name);
                }
            } else {
                return $file;
            }

        }

        return $image;
    }

    public function getId()
    {
        return $this->get('id');
    }

    public function getOwnerId()
    {
        return $this->get('owner_id');
    }

    public function belongsTo(User_Interface $user)
    {
        return ($this->getOwnerId() == $user->getId());
    }

    public function setOwner(User_Row $owner)
    {
        $this->set('owner_id', $owner->getId());

        return $this;
    }

    public function getName()
    {
        return htmlspecialchars($this->get('name'), ENT_QUOTES, 'UTF-8');
    }

    public function setName($name)
    {
        $this->set('name', $name);

        return $this;
    }

    public function getFilePath()
    {
        $path  = floor($this->getId() / 1000);
        $path .= sprintf('/%x-%u', $this->getOwnerId(), $this->getId());
        $path .= ".{$this->getExtension()}";

        return $path;
    }

    public function getExtension()
    {
        return $this->get('extension');
    }

    public function setExtension($extension)
    {
        $this->set('extension', $extension);

        return $this;
    }

    public function delete()
    {
        parent::delete();
        $path  = $this->getFilePath();
        if (!empty($path)) {
            $file = '.' . User_Avatar::STORAGE . $path;
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

    public function setFile($filePath)
    {
        $imageSize = getimagesize($filePath);
        $allowed   = Ext_Helper_Image::getAllowedTypes();
        if (isset($imageSize[2], $allowed[$imageSize[2]])) {
            if (filesize($filePath) > User_Avatar::MAX_WEIGHT) {
                $error = 'Размер файла превышает ' . User_Avatar::MAX_WEIGHT . ' байт';
                throw new Exception($error);
            }
            if ($imageSize[0] > User_Avatar::MAX_WIDTH * 10) {
                throw new Exception('Файл слишком большой.');
            }
            if ($imageSize[1] > User_Avatar::MAX_HEIGHT * 10) {
                throw new Exception('Файл слишком большой.');
            }
            $extension = $allowed[$imageSize[2]];
            $this->setExtension($extension);
            $this->save();
            $format  = '.' . User_Avatar::STORAGE . '/';
            $format .= floor($this->getId() / 1000) . '/%x-%d.';
            $dest  = sprintf($format, $this->getOwnerId(), $this->getId());
            $dest .= $extension;
            $options = array(
                'width'  => User_Avatar::MAX_WIDTH,
                'height' => User_Avatar::MAX_HEIGHT,
                'destination' => $dest,
                'imagesize'   => $imageSize,
            );
            $this->setExtension($extension);
            $this->save();
            Ext_Helper_Image::copyresized($filePath, $options);
        } else {
            throw new Exception('Недопустимый тип файла');
        }
    }
}
