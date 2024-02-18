<?php
class Profile
{
  private $id;
  private $culinary_interests;
  private $skill_level;

  public function __construct($culinary_interests, $skill_level, $id = null)
  {
    $this->culinary_interests = $culinary_interests;
    $this->skill_level = $skill_level;
    $this->id = $id;
  }

  public function getId()
  {
    return $this->id;
  }
  public function getCulinaryInterests()
  {
    return $this->culinary_interests;
  }
  public function getSkillLevel()
  {
    return $this->skill_level;
  }

  public function setId($id)
  {
    $this->id = $id;
  }
  public function setCulinaryInterests($culinary_interests)
  {
    $this->culinary_interests = $culinary_interests;
  }
  public function setSkillLevel($skill_level)
  {
    $this->skill_level = $skill_level;
  }
}