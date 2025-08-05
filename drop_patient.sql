
drop procedure delete_patient;
create procedure delete_patient(patient_id varchar(250))
begin

    delete
    from files
    where pk in (select *
                 from (select f.pk
                       from patient
                                join study s on patient.pk = s.patient_fk
                                join series on s.pk = series.study_fk
                                join instance on series.pk = instance.series_fk
                                join files f on instance.pk = f.instance_fk
                       where pat_id = patient_id) tmp);


    delete
    from instance
    where pk in (select *
                 from (select instance.pk
                       from patient
                                join study s on patient.pk = s.patient_fk
                                join series on s.pk = series.study_fk
                                join instance on series.pk = instance.series_fk
                       where pat_id = patient_id) tmp);

    delete
    from series
    where pk in (select *
                 from (select series.pk
                       from patient
                                join study s on patient.pk = s.patient_fk
                                join series on s.pk = series.study_fk
                       where pat_id = patient_id) tmp);


    delete
    from study_on_fs
    where study_fk in (select *
                       from (select study.pk
                             from patient
                                      join study on patient.pk = study.patient_fk
                             where pat_id = patient_id) tmp);

    delete
    from study
    where pk in (select *
                 from (select study.pk
                       from patient
                                join study on patient.pk = study.patient_fk
                       where pat_id = patient_id) tmp);

    delete from patient where pat_id = patient_id;

end;


call delete_patient('3673266918');

call delete_patient('1443446');

