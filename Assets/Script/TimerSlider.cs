using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class TimerSlider : MonoBehaviour
{
    public Slider timerSlider;
    public Text timerText; // Ÿ�̸� �ؽ�Ʈ�� ���� ����
    public Text totalTimeText; // ��ü �ð��� ǥ���� �ؽ�Ʈ ����
    public Image fadeImage; // ���̵���/���̵�ƿ��� ����� �̹���
    public GameObject[] objectsToActivate; // Ȱ��ȭ�� ���� ������Ʈ��
    public GameObject[] objectsToDeactivate; // ��Ȱ��ȭ�� ���� ������Ʈ��
    public float fadeDuration = 1f; // ���̵���/���̵�ƿ� ���� �ð�
    public float totalTime = 153f; // �� �ð� 2�� 33�� (153��)
    private float elapsedTime = 0f;

    private void Start()
    {
        // �����̴� �ʱ� ����
        timerSlider.minValue = 0f;
        timerSlider.maxValue = totalTime;
        timerSlider.value = 0f;

        // ��ü �ð� �ؽ�Ʈ �ʱ� ����
        UpdateTotalTimeText(totalTime);

        // Ÿ�̸� �ؽ�Ʈ �ʱ� ����
        UpdateTimerText(0); // 0���� ����

        // ���̵� �̹��� �ʱ� ����
        if (fadeImage != null)
        {
            fadeImage.color = new Color(0, 0, 0, 0); // �����ϰ� ����
            fadeImage.gameObject.SetActive(false); // ��Ȱ��ȭ
        }

        // Ÿ�̸� ����
        StartCoroutine(StartTimer());
    }

    private IEnumerator StartTimer()
    {
        while (elapsedTime < totalTime)
        {
            // ��� �ð� ������Ʈ
            elapsedTime += Time.deltaTime;
            // �����̴� �� ������Ʈ
            timerSlider.value = elapsedTime;
            // ��� �ð� ���
            float currentTime = elapsedTime;
            // Ÿ�̸� �ؽ�Ʈ ������Ʈ
            UpdateTimerText(currentTime);
            yield return null;
        }

        // Ÿ�̸Ӱ� ������ �� �����̴��� ���� ������ ����
        timerSlider.value = totalTime;
        UpdateTimerText(totalTime);

        // Ÿ�̸Ӱ� �����ڸ��� 1�� �� ������Ʈ ���� ����
        StartCoroutine(ActivateDeactivateObjectsAfterDelay(1f));

        // ���̵��� �� ���̵�ƿ� ����
        StartCoroutine(FadeInAndOut());
    }

    private void UpdateTimerText(float time)
    {
        time = Mathf.Max(time, 0); // time�� 0 ������ �������� �ʵ��� ����
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

        // ���� ������Ʈ Ȱ��ȭ
        foreach (GameObject obj in objectsToActivate)
        {
            obj.SetActive(true);
        }

        // ���� ������Ʈ ��Ȱ��ȭ
        foreach (GameObject obj in objectsToDeactivate)
        {
            obj.SetActive(false);
        }
    }

    private IEnumerator FadeInAndOut()
    {
        if (fadeImage != null)
        {
            fadeImage.gameObject.SetActive(true); // ���̵� �̹��� Ȱ��ȭ

            float elapsedTime = 0f;
            Color color = fadeImage.color;

            // ���̵���
            while (elapsedTime < fadeDuration)
            {
                elapsedTime += Time.deltaTime;
                float alpha = Mathf.Clamp01(elapsedTime / fadeDuration);
                fadeImage.color = new Color(color.r, color.g, color.b, alpha);
                yield return null;
            }

            fadeImage.color = new Color(color.r, color.g, color.b, 1f); // ������ �������ϰ� ����

            // 2�� ���
            yield return new WaitForSeconds(1f);

            elapsedTime = 0f;

            // ���̵�ƿ�
            while (elapsedTime < fadeDuration)
            {
                elapsedTime += Time.deltaTime;
                float alpha = Mathf.Clamp01(1f - (elapsedTime / fadeDuration));
                fadeImage.color = new Color(color.r, color.g, color.b, alpha);
                yield return null;
            }

            fadeImage.color = new Color(color.r, color.g, color.b, 0f); // ������ �����ϰ� ����
            fadeImage.gameObject.SetActive(false); // ���̵� �̹��� ��Ȱ��ȭ
        }
    }
}