package com.kks.trashpedia.report.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.kks.trashpedia.report.model.dao.ReportDao;
import com.kks.trashpedia.report.model.vo.Report;

@Service
public class ReportServiceImpl implements ReportService{
	@Autowired
	private ReportDao dao;

	@Override
	public Page<Report> getBoardReportList(Pageable pageable, int page, String sort, String searchSelect, String searchValue) {
		return dao.getBoardReportList(pageable, page, sort, searchSelect, searchValue);
	}

	@Override
	public Page<Report> getCommentReportList(Pageable pageable, int page, String sort, String searchSelect, String searchValue) {
		return dao.getCommentReportList(pageable, page, sort, searchSelect, searchValue);
	}
	
	
}
