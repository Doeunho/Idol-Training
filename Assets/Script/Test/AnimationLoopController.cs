using UnityEngine;
using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor.Animations;
#endif

public class AnimationLoopController : MonoBehaviour
{
    public Animator animator;
    public string animationClipName;
    public int loopCount = 3;
    public string boolParameterName;

    private int currentLoop = 0;

    void Update()
    {
        if (animator.GetCurrentAnimatorStateInfo(0).normalizedTime > 1 && !animator.IsInTransition(0))
        {
            currentLoop++;
            if (currentLoop >= loopCount)
            {
                animator.SetBool(boolParameterName, true);
                currentLoop = 0;
            }
            else
            {
                animator.Play(animationClipName, 0, 0f);
            }
        }
    }
}