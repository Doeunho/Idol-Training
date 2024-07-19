using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class TimerSlider : MonoBehaviour
{
    public Slider timerSlider;
    public Text timerText; // 타이머 텍스트를 위한 변수
    public Text totalTimeText; // 전체 시간을 표시할 텍스트 변수
    public Image fadeImage; // 페이드인/페이드아웃에 사용할 이미지
    public GameObject[] objectsToActivate; // 활성화할 게임 오브젝트들
    public GameObject[] objectsToDeactivate; // 비활성화할 게임 오브젝트들
    public float fadeDuration = 1f; // 페이드인/페이드아웃 지속 시간
    public float totalTime = 153f; // 총 시간 2분 33초 (153초)
    private float elapsedTime = 0f;

    private void Start()
    {
        // 슬라이더 초기 설정
        timerSlider.minValue = 0f;
        timerSlider.maxValue = totalTime;
        timerSlider.value = 0f;

        // 전체 시간 텍스트 초기 설정
        UpdateTotalTimeText(totalTime);

        // 타이머 텍스트 초기 설정
        UpdateTimerText(0); // 0부터 시작

        // 페이드 이미지 초기 설정
        if (fadeImage != null)
        {
            fadeImage.color = new Color(0, 0, 0, 0); // 투명하게 설정
            fadeImage.gameObject.SetActive(false); // 비활성화
        }

        // 타이머 시작
        StartCoroutine(StartTimer());
    }

    private IEnumerator StartTimer()
    {
        while (elapsedTime < totalTime)
        {
            // 경과 시간 업데이트
            elapsedTime += Time.deltaTime;
            // 슬라이더 값 업데이트
            timerSlider.value = elapsedTime;
            // 경과 시간 계산
            float currentTime = elapsedTime;
            // 타이머 텍스트 업데이트
            UpdateTimerText(currentTime);
            yield return null;
        }

        // 타이머가 끝났을 때 슬라이더를 최종 값으로 설정
        timerSlider.value = totalTime;
        UpdateTimerText(totalTime);

        // 타이머가 끝나자마자 1초 후 오브젝트 상태 변경
        StartCoroutine(ActivateDeactivateObjectsAfterDelay(1f));

        // 페이드인 및 페이드아웃 시작
        StartCoroutine(FadeInAndOut());
    }

    private void UpdateTimerText(float time)
    {
        time = Mathf.Max(time, 0); // time이 0 밑으로 떨어지지 않도록 설정
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

    private IEnumerator ActivateDeactivateObjectsAfterDelay(float delay)
    {
        yield return new WaitForSeconds(delay);

        // 게임 오브젝트 활성화
        foreach (GameObject obj in objectsToActivate)
        {
            obj.SetActive(true);
        }

        // 게임 오브젝트 비활성화
        foreach (GameObject obj in objectsToDeactivate)
        {
            obj.SetActive(false);
        }
    }

    private IEnumerator FadeInAndOut()
    {
        if (fadeImage != null)
        {
            fadeImage.gameObject.SetActive(true); // 페이드 이미지 활성화

            float elapsedTime = 0f;
            Color color = fadeImage.color;

            // 페이드인
            while (elapsedTime < fadeDuration)
            {
                elapsedTime += Time.deltaTime;
                float alpha = Mathf.Clamp01(elapsedTime / fadeDuration);
                fadeImage.color = new Color(color.r, color.g, color.b, alpha);
                yield return null;
            }

            fadeImage.color = new Color(color.r, color.g, color.b, 1f); // 완전히 불투명하게 설정

            // 2초 대기
            yield return new WaitForSeconds(1f);

            elapsedTime = 0f;

            // 페이드아웃
            while (elapsedTime < fadeDuration)
            {
                elapsedTime += Time.deltaTime;
                float alpha = Mathf.Clamp01(1f - (elapsedTime / fadeDuration));
                fadeImage.color = new Color(color.r, color.g, color.b, alpha);
                yield return null;
            }

            fadeImage.color = new Color(color.r, color.g, color.b, 0f); // 완전히 투명하게 설정
            fadeImage.gameObject.SetActive(false); // 페이드 이미지 비활성화
        }
    }
}