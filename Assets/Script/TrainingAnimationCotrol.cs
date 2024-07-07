using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class TrainingAnimationCotrol : MonoBehaviour
{
    [SerializeField] Animator TrainingAni;

    private void Update()
    {
        {
            if (Input.GetMouseButtonDown(0))
            {
                TrainingAni.SetBool("Stop" , true);
            }
        }
    }

 

}
