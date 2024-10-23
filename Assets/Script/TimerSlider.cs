using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using Cysharp.Threading.Tasks;
using System.Threading;
using System;

public class TimerSlider : MonoBehaviour
{
    public Slider timerSlider;
    public Text timerText;
    public Text totalTimeText;
    public float totalTime = 153f;
    private float elapsedTime = 0f;
    private CancellationTokenSource _cancellationTokenSource;

    private async void Start()
    {
        _cancellationTokenSource = new CancellationTokenSource();

        // 슬라이더 초기 설정
        timerSlider.minValue = 0f;
        timerSlider.maxValue = totalTime;
        timerSlider.value = 0f;

        // 전체 시간 텍스트 초기 설정
        UpdateTotalTimeText(totalTime);

        // 타이머 텍스트 초기 설정
        UpdateTimerText(0);

        // 타이머 시작
        await StartTimerAsync(_cancellationTokenSource.Token);
    }

    private void OnDestroy()
    {
        _cancellationTokenSource?.Cancel();
        _cancellationTokenSource?.Dispose();
    }

    private async UniTask StartTimerAsync(CancellationToken cancellationToken)
    {
        try
        {
            while (elapsedTime < totalTime)
            {
                await UniTask.Yield(PlayerLoopTiming.Update, cancellationToken);

                elapsedTime += Time.deltaTime;
                timerSlider.value = elapsedTime;
                UpdateTimerText(elapsedTime);
            }

            timerSlider.value = totalTime;
            UpdateTimerText(totalTime);

            // 1초 대기 후 오브젝트 상태 변경
            await UniTask.Delay(1000, cancellationToken: cancellationToken);
        }
        catch (OperationCanceledException)
        {
            Debug.Log("Timer operation was cancelled");
        }
    }

    private void UpdateTimerText(float time)
    {
        time = Mathf.Max(time, 0);
        int minutes = Mathf.FloorToInt(time / 60F);
        int seconds = Mathf.FloorToInt(time % 60F);
        timerText.text = string.Format("{0:00}:{1:00}", minutes, seconds);
    }

    private void UpdateTotalTimeText(float time)
    {
        int minutes = Mathf.FloorToInt(time / 60F);
        int seconds = Mathf.FloorToInt(time % 60F);
        totalTimeText.text = string.Format("{0:00}:{1:00}", minutes, seconds);
    }
}