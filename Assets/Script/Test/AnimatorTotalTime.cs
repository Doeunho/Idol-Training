using UnityEngine;
using UnityEngine.UI;

public class AnimationTimer : MonoBehaviour
{
    public Animator animator;
    public Text timerText;
    public AnimationLoopController loopController;

    private float startTime;
    private float elapsedTime;
    private float totalAnimationLength;

    void Start()
    {
        if (animator == null) animator = GetComponent<Animator>();
        if (loopController == null) loopController = GetComponent<AnimationLoopController>();

        if (animator == null || loopController == null)
        {
            Debug.LogError("Required components are missing!");
            enabled = false;
            return;
        }

        CalculateTotalAnimationLength();
        ResetTimer();
    }

    void Update()
    {
        elapsedTime = Time.time - startTime;
        UpdateTimerDisplay();
    }

    void ResetTimer()
    {
        startTime = Time.time;
        elapsedTime = 0f;
    }

    void UpdateTimerDisplay()
    {
        float totalTime = totalAnimationLength * loopController.loopCount;
        float remainingTime = Mathf.Max(0, totalTime - elapsedTime);
        int minutes = Mathf.FloorToInt(remainingTime / 60f);
        int seconds = Mathf.FloorToInt(remainingTime % 60f);
        timerText.text = string.Format("{0:00}:{1:00}", minutes, seconds);

        if (remainingTime <= 0)
        {
            timerText.text = "00:00(¿Ï·á)";
        }
    }

    void CalculateTotalAnimationLength()
    {
        totalAnimationLength = 0f;
        RuntimeAnimatorController ac = animator.runtimeAnimatorController;

        foreach (AnimationClip clip in ac.animationClips)
        {
            totalAnimationLength += clip.length;
            Debug.Log($"Animation clip: {clip.name}, Length: {clip.length}");
        }

        Debug.Log($"Total animation length: {totalAnimationLength}");
    }
}