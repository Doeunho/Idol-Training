using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationLoopController : MonoBehaviour
{
    [SerializeField] private Animator animator;
    [SerializeField] private string currentStateName;
    [SerializeField] private string nextStateName;
    [SerializeField] private int loopcount = 3;

    private int currentloop = 0;

    public void Test()
    {
        if (animator.GetCurrentAnimatorStateInfo(0).normalizedTime > 1 && !animator.IsInTransition(0))
        {
            currentloop++;

            if (currentloop >= loopcount)
            {
                animator.Play(nextStateName);
                currentloop = 0;
            }
            else
            {
                animator.Play(currentStateName, 0, 0f);
            }
        }
    }
}
