using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class TrainingAnimationCotrol : MonoBehaviour
{
    [SerializeField] Animator TrainingAni;
    [SerializeField] GameObject GameLodingRoom1;
    [SerializeField] GameObject GameLodingRoom2;
    [SerializeField] GameObject GameLodingRoom3;
    [SerializeField] GameObject GameLodingRoom4;
    [SerializeField] GameObject GameLodingRoom5;

    [SerializeField] GameObject InstructorMao1;
    [SerializeField] GameObject InstructorMao2;
    [SerializeField] GameObject InstructorMao3;
    [SerializeField] GameObject InstructorMao4;
    [SerializeField] GameObject InstructorMao5;

    void Update()
    { 

    }

    public void OnAnimationEnd()
    {
        gameObject.SetActive(false);
    }

    public void OnClick_Training1()
    {
        InstructorMao1.SetActive(true);
        GameLodingRoom1.SetActive(false);
        gameObject.SetActive(true);
        TrainingAni.SetBool("Stop", true);
    }

    public void OnClick_Training2()
    {
        InstructorMao2.SetActive(true);
        GameLodingRoom2.SetActive(false);
        gameObject.SetActive(true);
        TrainingAni.SetBool("Stop2", true);
    }

    public void OnClick_Training3()
    {
        InstructorMao3.SetActive(true);
        GameLodingRoom3.SetActive(false);
        gameObject.SetActive(true);
        TrainingAni.SetBool("Stop3", true);
    }
    public void OnClick_Training4()
    {
        InstructorMao4.SetActive(true);
        GameLodingRoom4.SetActive(false);
        gameObject.SetActive(true);
        TrainingAni.SetBool("Stop4", true);
    }
    public void OnClick_Training5()
    {
        InstructorMao5.SetActive(true);
        GameLodingRoom5.SetActive(false);
        gameObject.SetActive(true);
        TrainingAni.SetBool("Stop5", true);
    }
}
