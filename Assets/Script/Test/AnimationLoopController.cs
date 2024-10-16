using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationLoopController : MonoBehaviour
{
    [SerializeField] private Animator animator;
    [SerializeField] private string currentStateName;
    [SerializeField] private string nextStateName;
    [SerializeField] private int loopcount = 3;

    [SerializeField] private int currentloop = 0;
    private bool isTransitioning = false;

    private void Update()
    {
        Test();
    }

    private void Awake()
    {
        animator = GetComponent<Animator>();
    }

    public void Test()
    {
        {
            if (animator == null) return;

            AnimatorStateInfo stateInfo = animator.GetCurrentAnimatorStateInfo(0);

            if (stateInfo.IsName(currentStateName))
            {
                if (stateInfo.normalizedTime % 1f > 0.99f && !isTransitioning)
                {
                    currentloop++;
                    isTransitioning = true;

                    if (currentloop >= loopcount)
                    {
                        animator.Play(nextStateName, 0, 0f);
                        currentloop = 0;
                    }
                    else
                    {
                        animator.Play(currentStateName, 0, 0f);
                    }
                }
                else if (stateInfo.normalizedTime % 1f < 0.01f)
                {
                    isTransitioning = false;
                }
            }
        }
    }
}

