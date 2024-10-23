using UnityEngine;

public class AnimationLoopController : MonoBehaviour
{
    [SerializeField] private Animator animator;
    [SerializeField] public int loopCount = 2;
    [SerializeField] public int currentLoop = 0;
    [SerializeField] private string boolParameterName = "isTraining";
    [SerializeField] private int currentStateIndex = 0;
    private float lastNormalizedTime = 0f;
    private bool isAnimationPlaying = false;

    public AnimationTotalTimer animationTimer;

    void Start()
    {
        if (animator == null)
        {
            animator = GetComponentInChildren<Animator>();
        }
        if (animationTimer == null)
        {
            animationTimer = GetComponent<AnimationTotalTimer>();
        }
        ResetLoop();
    }

    void Update()
    {
        if (animator == null) return;
        AnimatorStateInfo stateInfo = animator.GetCurrentAnimatorStateInfo(0);
        switch (currentStateIndex)
        {
            case 0: // Kickback_1
                if (stateInfo.normalizedTime >= 1)
                {
                    currentStateIndex = 1;
                    lastNormalizedTime = 0f;
                    isAnimationPlaying = false;
                }
                break;
            case 1: // Kickback_2 (looping state)
                float normalizedTime = stateInfo.normalizedTime % 1;
                if (!isAnimationPlaying)
                {
                    isAnimationPlaying = true;
                    lastNormalizedTime = normalizedTime;
                }
                else if (normalizedTime < lastNormalizedTime)
                {
                    currentLoop++;
                    Debug.Log($"루프 완료. 현재 루프: {currentLoop}/{loopCount}");
                    if (currentLoop >= loopCount)
                    {
                        currentStateIndex = 2;
                        animator.SetBool(boolParameterName, true);
                        Debug.Log("애니메이션 루프 완료. Kickback_3으로 이동합니다.");
                        isAnimationPlaying = false;
                    }
                }
                lastNormalizedTime = normalizedTime;
                break;
            case 2: // Kickback_3
                // Kickback_3에서는 특별한 처리를 하지 않습니다. 타이머는 계속 실행됩니다.
                break;
        }
    }

    public void ResetLoop()
    {
        currentLoop = 0;
        lastNormalizedTime = 0f;
        isAnimationPlaying = false;
        currentStateIndex = 0;
        animator.SetBool(boolParameterName, false);
        Debug.Log("애니메이션 루프 리셋. Kickback_1부터 시작합니다.");
        if (animationTimer != null)
        {
            animationTimer.StartTimer();
        }
    }
}