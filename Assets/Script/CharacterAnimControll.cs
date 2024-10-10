using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterAnimControll : MonoBehaviour
{
    [SerializeField] Animator Animator_Character;

    private void Awake()
    {
        Animator_Character = GetComponent<Animator>();
    }

    public void PlaySpecificAnimation(string animKey)
    {
        Animator_Character.SetTrigger(animKey);
    }
}
