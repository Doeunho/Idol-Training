using Unity.VisualScripting.Dependencies.Sqlite;
using UnityEngine;
using UnityEngine.UI;

public class AnimationTotalTimer : MonoBehaviour
{
    [SerializeField] private Animator animator;
    [SerializeField] private Text timerText;
    [SerializeField] private AnimationLoopController loopController;
    [SerializeField] private Slider progressSlider;
    private float startTime;
    private float totalAnimationLength;
    private bool isTimerRunning = false;
    private RuntimeAnimatorController lastAnimatorController;

    void Start()
    {
        if (animator == null) animator = GetComponentInChildren<Animator>();
        if (loopController == null) loopController = GetComponent<AnimationLoopController>();
        if (animator == null || loopController == null)
        {
            Debug.LogError("�ʿ��� ������Ʈ�� �����ϴ�!");
            enabled = false;
            return;
        }

        if (progressSlider != null)
        {
            progressSlider.minValue = 0f;
            progressSlider.maxValue = 1f;
            progressSlider.value = 0f;
        }
        lastAnimatorController = animator.runtimeAnimatorController;
        CalculateTotalAnimationLength();
    }

    void Update()
    {
        if (CheckAnimatorControllerChanged())
        {
            ResetTimerAndRecalculate();
        }

        if (isTimerRunning)
        {
            UpdateTimerDisplay();
            UpdateProgressSlider();
        }
    }

    bool CheckAnimatorControllerChanged()
    {
        if (animator.runtimeAnimatorController != lastAnimatorController)
        {
            lastAnimatorController = animator.runtimeAnimatorController;
            return true;
        }
        return false;
    }

    void ResetTimerAndRecalculate()
    {
        Debug.Log("�ִϸ����� ��Ʈ�ѷ��� ����Ǿ����ϴ�. Ÿ�̸Ӹ� �ʱ�ȭ�մϴ�.");
        StopTimer();
        CalculateTotalAnimationLength();
        StartTimer();
        if (loopController != null)
        {
            loopController.ResetLoop();
        }

        if (progressSlider == null)
        {
            progressSlider.value = 0f;
        }
    }

    public void StartTimer()
    {
        startTime = Time.time;
        isTimerRunning = true;
    }

    public void StopTimer()
    {
        isTimerRunning = false;
    }

    void UpdateTimerDisplay()
    {
        float elapsedTime = Time.time - startTime;
        float remainingTime = Mathf.Max(0, totalAnimationLength - elapsedTime);
        int minutes = Mathf.FloorToInt(remainingTime / 60f);
        int seconds = Mathf.FloorToInt(remainingTime % 60f);
        timerText.text = string.Format("{0:00}:{1:00}", minutes, seconds);
        if (remainingTime <= 0)
        {
            timerText.text = "00:00";
            StopTimer();

            if(progressSlider != null)
            {
                progressSlider.value = 1f;
            }
        }
    }

    void UpdateProgressSlider()
    {
        if (progressSlider != null && totalAnimationLength > 0)
        {
            float elapsedTime = Time.time - startTime;
            float progress = Mathf.Clamp01(elapsedTime / totalAnimationLength);
            progressSlider.value = progress;
        }
    }

    void CalculateTotalAnimationLength()
    {
        totalAnimationLength = 0f;
        AnimationClip[] clips = animator.runtimeAnimatorController.animationClips;

        if (clips.Length < 3)
        {
            Debug.LogError("�ִϸ��̼� Ŭ���� ���� ����� ������ ������ �����ϴ�.");
            return;
        }

        totalAnimationLength += clips[0].length; // Kickback_1
        totalAnimationLength += clips[1].length * (loopController.loopCount + 2); // Kickback_2 (looping state)
        totalAnimationLength += clips[2].length; // Kickback_3

        Debug.Log($"�� �ִϸ��̼� ����: {totalAnimationLength}");

        if (progressSlider != null)
        {
            progressSlider.value = 0f;
        }
    }
}