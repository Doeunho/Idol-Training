using UnityEngine;
using UnityEditor.Animations;
public class AnimationLoopController : MonoBehaviour
{
    [SerializeField] private Animator animator;
    [SerializeField] public string animationStateName;  // 애니메이션 클립 이름 대신 상태 이름 사용
    [SerializeField] public int loopCount = 2;
    [SerializeField] public int currentLoop = 0;
    [SerializeField] private string boolParameterName = "isTraining";
    private float lastNormalizedTime = 0f;
    private bool isAnimationPlaying = false;

    void Start()
    {
        if (animator == null)
        {
            animator = GetComponent<Animator>();
        }
        ResetLoop();
    }

    void Update()
    {
        if (animator == null) return;
        AnimatorStateInfo stateInfo = animator.GetCurrentAnimatorStateInfo(0);

        if (stateInfo.IsName(animationStateName))
        {
            float normalizedTime = stateInfo.normalizedTime % 1;
            if (!isAnimationPlaying)
            {
                isAnimationPlaying = true;
                lastNormalizedTime = normalizedTime;
            }
            else if (normalizedTime < lastNormalizedTime)
            {
                currentLoop++;
                Debug.Log($"Loop completed. Current loop: {currentLoop}/{loopCount}");
                if (currentLoop >= loopCount)
                {
                    animator.SetBool(boolParameterName, true);
                    Debug.Log("Animation loops completed. Boolean set to true.");
                    isAnimationPlaying = false;
                }
            }
            lastNormalizedTime = normalizedTime;
        }
        else
        {
            isAnimationPlaying = false;
        }
    }

    public void ResetLoop()
    {
        currentLoop = 0;
        lastNormalizedTime = 0f;
        isAnimationPlaying = false;
        animator.SetBool(boolParameterName, false);
        Debug.Log("Animation loop reset. Boolean set to false.");
    }
}