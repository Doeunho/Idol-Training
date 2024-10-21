using Unity.VisualScripting.Dependencies.Sqlite;
using UnityEngine;
using UnityEngine.UI;

public class AnimationTimer : MonoBehaviour
{
    [SerializeField] private Animator animator;
    [SerializeField] private Text timerText;
    [SerializeField] private AnimationLoopController loopController;
    private float startTime;
    private float totalAnimationLength;
    private bool isTimerRunning = false;
    private RuntimeAnimatorController lastAnimatorController;

    void Start()
    {
        if (animator == null) animator = GetComponent<Animator>();
        if (loopController == null) loopController = GetComponent<AnimationLoopController>();
        if (animator == null || loopController == null)
        {
            Debug.LogError("�ʿ��� ������Ʈ�� �����ϴ�!");
            enabled = false;
            return;
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
            timerText.text = "00:00(�Ϸ�)";
            StopTimer();
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
    }
}