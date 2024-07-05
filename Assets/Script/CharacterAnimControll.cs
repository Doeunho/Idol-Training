using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterAnimControll : MonoBehaviour
{
    [SerializeField] Animator Animator_Character;

    public void PlaySpecificAnimation(string animKey)
    {
        Animator_Character.SetTrigger(animKey);
    }
}
