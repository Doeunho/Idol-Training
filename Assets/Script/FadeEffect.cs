using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class FadeController : MonoBehaviour
{
    public Image fadeImage;  // ���̵� ȿ���� ����� �̹���
    public float fadeDuration = 1f;  // ���̵�ƿ� ���� �ð�

    private CanvasGroup canvasGroup;

    private void Start()
    {
        // CanvasGroup ������Ʈ �߰� �� �ʱ� ����
        canvasGroup = fadeImage.GetComponent<CanvasGroup>();
        if (canvasGroup == null)
        {
            canvasGroup = fadeImage.gameObject.AddComponent<CanvasGroup>();
        }

        // CanvasGroup �ʱ� ����
        canvasGroup.alpha = 1f;
        canvasGroup.blocksRaycasts = false; // Raycast�� �������� �ʵ��� ����

        // ȭ�鿡 ������ �ʵ��� �ʱ� ����
        fadeImage.gameObject.SetActive(false);

    }

    public void StartFadeOut()
    {
        // �̹����� Ȱ��ȭ�ϰ� ���̵�ƿ� ����
        fadeImage.gameObject.SetActive(true);
        StartCoroutine(FadeOutAfterDelay(1f));  // 2�� �� ���̵�ƿ� ����
    }

    private IEnumerator FadeOutAfterDelay(float delay)
    {
        // ������ �ð�(2��) ���� ���
        yield return new WaitForSeconds(delay);

        // ���̵�ƿ� ����
        float startAlpha = 1f;
        float endAlpha = 0f;
        float elapsedTime = 0;

        while (elapsedTime < fadeDuration)
        {
            elapsedTime += Time.deltaTime;
            float alpha = Mathf.Lerp(startAlpha, endAlpha, elapsedTime / fadeDuration);
            canvasGroup.alpha = alpha;
            yield return null;
        }

        // ���̵� �Ϸ� �� ���İ��� ������ 0���� �����ϰ� �̹����� ��Ȱ��ȭ
        canvasGroup.alpha = 0f;
        fadeImage.gameObject.SetActive(false);
    }
}
